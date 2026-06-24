#!/usr/bin/env bash
# Rebuilds the portfolio inside your existing repo as a clean, staged history.
# Run from the root of your Arehone_Portofolio repo:  bash rebuild.sh
set -e

if [ ! -d .git ]; then
  echo "Run this from the root of your repo (the folder that contains the .git directory)."; exit 1
fi
cd "$(git rev-parse --show-toplevel)"
D=MyPortofolio
mkdir -p "$D/css" "$D/js" "$D/images"

commit () { git add -A; git commit -q -m "$1"; echo "  committed: $1"; }

# ----- 1 -----
rm -rf "$D/html"
rm -f "$D/css/about.css" "$D/css/contact.css" "$D/css/education.css" "$D/css/experience.css" "$D/css/index.css" "$D/css/projects.css"
rm -f "$D/main.js" "$D/index.html"
commit "Remove legacy multi-page site"

# ----- 2 -----
cat > "$D/css/style.css" <<'ARH_EOF'
/* =========================================================
   Arehone Mbadaliga - Portfolio
   Palette: deep navy canvas, brand navy/blue, gold accent
   ========================================================= */

:root {
  --ink: #0c1626;          /* deepest background */
  --navy: #15233d;         /* surface */
  --navy-2: #1f3864;       /* brand navy */
  --blue: #2b5daa;         /* brand blue */
  --blue-soft: #4f86d6;    /* hover / links */
  --gold: #e0a82e;         /* accent from logo */
  --gold-soft: #f0c04a;
  --paper: #f5f7fb;        /* primary text */
  --muted: #9fb0cc;        /* secondary text */
  --line: rgba(159, 176, 204, 0.16);
  --card: rgba(255, 255, 255, 0.03);
  --card-hover: rgba(79, 134, 214, 0.10);

  --display: "Space Grotesk", "Segoe UI", sans-serif;
  --body: "Inter", "Segoe UI", system-ui, sans-serif;
  --mono: "JetBrains Mono", "Consolas", monospace;

  --maxw: 1120px;
  --radius: 14px;
}

* { box-sizing: border-box; margin: 0; padding: 0; }

html { scroll-behavior: smooth; scroll-padding-top: 84px; }

body {
  font-family: var(--body);
  background: var(--ink);
  color: var(--paper);
  line-height: 1.65;
  -webkit-font-smoothing: antialiased;
  overflow-x: hidden;
}

a { color: inherit; text-decoration: none; }
img { max-width: 100%; display: block; }
ul { list-style: none; }

.wrap { width: 100%; max-width: var(--maxw); margin: 0 auto; padding: 0 24px; }

/* ---------- Shared section scaffolding ---------- */
.block { padding: 96px 0; position: relative; }
.eyebrow {
  font-family: var(--mono);
  font-size: 0.78rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--gold);
  display: inline-block;
  margin-bottom: 14px;
}
.block-title {
  font-family: var(--display);
  font-size: clamp(1.8rem, 4vw, 2.6rem);
  font-weight: 600;
  letter-spacing: -0.01em;
  line-height: 1.1;
  margin-bottom: 18px;
}
.block-intro { color: var(--muted); max-width: 640px; margin-bottom: 48px; }

/* ---------- Navbar ---------- */
.navbar {
  position: fixed; top: 0; left: 0; right: 0; z-index: 100;
  display: flex; align-items: center; justify-content: space-between;
  padding: 14px 24px;
  background: rgba(12, 22, 38, 0.72);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid transparent;
  transition: border-color 0.3s ease, background 0.3s ease;
}
.navbar.scrolled { border-bottom-color: var(--line); }
.brand { display: flex; align-items: center; gap: 10px; font-family: var(--display); font-weight: 600; }
.brand img { width: 38px; height: 38px; border-radius: 8px; object-fit: cover; }
.brand span { font-size: 1rem; letter-spacing: -0.01em; }
.brand small { display: block; font-family: var(--mono); font-size: 0.6rem; color: var(--gold); letter-spacing: 0.14em; text-transform: uppercase; }

.nav-links { display: flex; gap: 28px; align-items: center; }
.nav-links a {
  font-size: 0.9rem; color: var(--muted); position: relative; padding: 4px 0;
  transition: color 0.2s ease;
}
.nav-links a::after {
  content: ""; position: absolute; left: 0; bottom: -2px; height: 2px; width: 0;
  background: var(--gold); transition: width 0.25s ease;
}
.nav-links a:hover, .nav-links a.active { color: var(--paper); }
.nav-links a:hover::after, .nav-links a.active::after { width: 100%; }

.nav-toggle { display: none; background: none; border: 0; cursor: pointer; flex-direction: column; gap: 5px; }
.nav-toggle span { width: 24px; height: 2px; background: var(--paper); transition: transform 0.3s ease, opacity 0.3s ease; }

/* ---------- Hero ---------- */
.hero {
  min-height: 100vh; display: flex; align-items: center;
  position: relative; overflow: hidden; padding-top: 70px;
}
.hero-grid {
  position: absolute; inset: 0; z-index: 0;
  background-image:
    radial-gradient(circle at 78% 18%, rgba(43, 93, 170, 0.28), transparent 45%),
    radial-gradient(circle at 12% 88%, rgba(224, 168, 46, 0.10), transparent 42%),
    linear-gradient(var(--line) 1px, transparent 1px),
    linear-gradient(90deg, var(--line) 1px, transparent 1px);
  background-size: auto, auto, 46px 46px, 46px 46px;
  mask-image: radial-gradient(circle at 60% 40%, black, transparent 95%);
}
.hero .wrap { position: relative; z-index: 1; }
.status {
  display: inline-flex; align-items: center; gap: 9px;
  font-family: var(--mono); font-size: 0.78rem; color: var(--muted);
  border: 1px solid var(--line); border-radius: 999px; padding: 6px 14px; margin-bottom: 26px;
}
.dot { width: 8px; height: 8px; border-radius: 50%; background: var(--gold); box-shadow: 0 0 0 0 rgba(224,168,46,0.6); animation: pulse 2.4s infinite; }
@keyframes pulse { 0% { box-shadow: 0 0 0 0 rgba(224,168,46,0.5);} 70% { box-shadow: 0 0 0 10px rgba(224,168,46,0);} 100% { box-shadow: 0 0 0 0 rgba(224,168,46,0);} }

.hero h1 {
  font-family: var(--display); font-weight: 700;
  font-size: clamp(2.6rem, 7vw, 5rem); line-height: 1.02; letter-spacing: -0.02em;
  margin-bottom: 18px;
}
.hero h1 .accent { color: var(--gold); }
.role-line { font-size: clamp(1.05rem, 2.5vw, 1.4rem); color: var(--paper); font-weight: 500; margin-bottom: 18px; }
.role-line .rotator { color: var(--blue-soft); font-family: var(--mono); }
.hero p.lead { color: var(--muted); max-width: 560px; font-size: 1.05rem; margin-bottom: 34px; }

.hero-buttons { display: flex; gap: 14px; flex-wrap: wrap; }
.btn {
  font-family: var(--body); font-weight: 600; font-size: 0.95rem;
  padding: 13px 26px; border-radius: 10px; cursor: pointer; border: 1px solid transparent;
  transition: transform 0.18s ease, box-shadow 0.18s ease, background 0.18s ease, border-color 0.18s ease;
  display: inline-flex; align-items: center; gap: 9px;
}
.btn.primary { background: var(--gold); color: #1a1205; }
.btn.primary:hover { background: var(--gold-soft); transform: translateY(-2px); box-shadow: 0 10px 26px rgba(224,168,46,0.28); }
.btn.ghost { border-color: var(--line); color: var(--paper); }
.btn.ghost:hover { border-color: var(--blue-soft); color: var(--blue-soft); transform: translateY(-2px); }

.hero-meta { display: flex; gap: 26px; margin-top: 48px; flex-wrap: wrap; }
.hero-meta div { display: flex; flex-direction: column; }
.hero-meta b { font-family: var(--display); font-size: 1.6rem; color: var(--paper); }
.hero-meta small { font-family: var(--mono); font-size: 0.72rem; color: var(--muted); letter-spacing: 0.06em; text-transform: uppercase; }

/* ---------- About ---------- */
.about-grid { display: grid; grid-template-columns: 1.4fr 1fr; gap: 56px; align-items: start; }
.about-text p { color: var(--muted); margin-bottom: 18px; }
.about-text p strong { color: var(--paper); }
.about-card {
  background: var(--card); border: 1px solid var(--line); border-radius: var(--radius); padding: 26px;
}
.about-card h4 { font-family: var(--mono); font-size: 0.75rem; letter-spacing: 0.1em; text-transform: uppercase; color: var(--gold); margin-bottom: 16px; }
.about-card .row { display: flex; justify-content: space-between; gap: 12px; padding: 11px 0; border-bottom: 1px dashed var(--line); font-size: 0.92rem; }
.about-card .row:last-child { border-bottom: 0; }
.about-card .row span:first-child { color: var(--muted); }
.about-card .row span:last-child { color: var(--paper); text-align: right; font-weight: 500; }

/* ---------- Skills ---------- */
.skills-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 22px; }
.skill-card {
  background: var(--card); border: 1px solid var(--line); border-radius: var(--radius);
  padding: 26px; transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
}
.skill-card:hover { transform: translateY(-4px); border-color: rgba(79,134,214,0.4); background: var(--card-hover); }
.skill-card .num { font-family: var(--mono); font-size: 0.78rem; color: var(--gold); }
.skill-card h3 { font-family: var(--display); font-size: 1.2rem; font-weight: 600; margin: 6px 0 16px; }
.tags { display: flex; flex-wrap: wrap; gap: 8px; }
.tag {
  font-family: var(--mono); font-size: 0.74rem; color: var(--muted);
  border: 1px solid var(--line); border-radius: 7px; padding: 5px 10px; transition: color 0.2s ease, border-color 0.2s ease;
}
.skill-card:hover .tag { color: var(--paper); }
.skill-card.wide { grid-column: span 2; }

/* ---------- Experience timeline ---------- */
.timeline { position: relative; margin-left: 8px; }
.timeline::before { content: ""; position: absolute; left: 7px; top: 6px; bottom: 6px; width: 2px; background: var(--line); }
.tl-item { position: relative; padding: 0 0 38px 40px; }
.tl-item:last-child { padding-bottom: 0; }
.tl-item::before {
  content: ""; position: absolute; left: 0; top: 6px; width: 16px; height: 16px; border-radius: 50%;
  background: var(--ink); border: 2px solid var(--blue); 
}
.tl-item.now::before { border-color: var(--gold); background: var(--gold); box-shadow: 0 0 0 4px rgba(224,168,46,0.18); }
.tl-date { font-family: var(--mono); font-size: 0.76rem; color: var(--gold); letter-spacing: 0.04em; }
.tl-item h3 { font-family: var(--display); font-size: 1.18rem; font-weight: 600; margin: 4px 0 2px; }
.tl-org { color: var(--blue-soft); font-size: 0.92rem; margin-bottom: 12px; }
.tl-item ul li { color: var(--muted); font-size: 0.93rem; padding-left: 18px; position: relative; margin-bottom: 6px; }
.tl-item ul li::before { content: "▸"; position: absolute; left: 0; color: var(--blue); }

/* ---------- Projects ---------- */
.proj-filter { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 34px; }
.chip {
  font-family: var(--mono); font-size: 0.78rem; color: var(--muted);
  background: none; border: 1px solid var(--line); border-radius: 999px; padding: 7px 16px; cursor: pointer;
  transition: all 0.2s ease;
}
.chip:hover { color: var(--paper); border-color: var(--blue-soft); }
.chip.active { background: var(--gold); color: #1a1205; border-color: var(--gold); }

.proj-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 22px; }
.proj-card {
  background: var(--card); border: 1px solid var(--line); border-radius: var(--radius); padding: 24px;
  display: flex; flex-direction: column; transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
}
.proj-card:hover { transform: translateY(-5px); border-color: rgba(79,134,214,0.4); background: var(--card-hover); }
.proj-cat { font-family: var(--mono); font-size: 0.72rem; color: var(--gold); letter-spacing: 0.06em; text-transform: uppercase; margin-bottom: 10px; }
.proj-card h3 { font-family: var(--display); font-size: 1.1rem; font-weight: 600; margin-bottom: 10px; }
.proj-card p { color: var(--muted); font-size: 0.9rem; flex: 1; }
.proj-stack { display: flex; flex-wrap: wrap; gap: 7px; margin-top: 16px; }
.proj-stack span { font-family: var(--mono); font-size: 0.7rem; color: var(--blue-soft); border: 1px solid var(--line); border-radius: 6px; padding: 3px 8px; }
.proj-links { margin-top: 16px; display: flex; gap: 16px; }
.proj-links a { font-family: var(--mono); font-size: 0.78rem; color: var(--gold); border-bottom: 1px solid transparent; transition: border-color 0.2s ease; }
.proj-links a:hover { border-color: var(--gold); }

/* ---------- Education + Certs ---------- */
.edu-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 56px; }
.edu-item { padding: 16px 0; border-bottom: 1px solid var(--line); }
.edu-item:last-child { border-bottom: 0; }
.edu-item h3 { font-family: var(--display); font-size: 1.05rem; font-weight: 600; }
.edu-item .school { color: var(--blue-soft); font-size: 0.9rem; }
.edu-item .when { font-family: var(--mono); font-size: 0.74rem; color: var(--muted); }
.edu-item .desc { color: var(--muted); font-size: 0.88rem; margin-top: 8px; }
.edu-item .sponsor { font-family: var(--mono); font-size: 0.72rem; color: var(--gold); margin-top: 8px; }
.cert-list { display: flex; flex-direction: column; gap: 10px; }
.cert {
  display: flex; align-items: center; gap: 12px; font-size: 0.92rem; color: var(--muted);
  background: var(--card); border: 1px solid var(--line); border-radius: 10px; padding: 12px 16px;
  transition: border-color 0.2s ease, color 0.2s ease;
}
.cert:hover { border-color: rgba(224,168,46,0.4); color: var(--paper); }
.cert .ic { color: var(--gold); font-family: var(--mono); font-size: 0.8rem; }
.cert .meta { margin-left: auto; font-family: var(--mono); font-size: 0.72rem; color: var(--muted); }

/* ---------- Contact ---------- */
.contact { background: linear-gradient(180deg, var(--ink), var(--navy)); }
.contact-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 56px; align-items: start; }
.contact-links { display: flex; flex-direction: column; gap: 14px; margin-top: 8px; }
.clink {
  display: flex; align-items: center; gap: 14px; padding: 14px 18px;
  border: 1px solid var(--line); border-radius: 12px; transition: all 0.2s ease;
}
.clink:hover { border-color: var(--gold); transform: translateX(4px); }
.clink .ic { width: 38px; height: 38px; display: grid; place-items: center; border-radius: 9px; background: rgba(43,93,170,0.18); color: var(--gold); font-family: var(--mono); font-weight: 600; }
.clink small { display: block; color: var(--muted); font-size: 0.72rem; font-family: var(--mono); text-transform: uppercase; letter-spacing: 0.06em; }
.clink b { font-weight: 500; font-size: 0.96rem; }

.contact-form { display: flex; flex-direction: column; gap: 14px; }
.contact-form .pair { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.contact-form input, .contact-form textarea {
  font-family: var(--body); font-size: 0.95rem; color: var(--paper);
  background: var(--card); border: 1px solid var(--line); border-radius: 10px; padding: 13px 15px; width: 100%;
  transition: border-color 0.2s ease;
}
.contact-form input:focus, .contact-form textarea:focus { outline: none; border-color: var(--blue-soft); }
.contact-form textarea { resize: vertical; min-height: 130px; }
.form-note { font-size: 0.8rem; color: var(--muted); }

/* ---------- Footer ---------- */
footer { border-top: 1px solid var(--line); padding: 28px 0; }
footer .wrap { display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; }
footer p { color: var(--muted); font-size: 0.85rem; }
footer .socials { display: flex; gap: 18px; }
footer .socials a { color: var(--muted); font-family: var(--mono); font-size: 0.82rem; transition: color 0.2s ease; }
footer .socials a:hover { color: var(--gold); }

/* ---------- Reveal animation ---------- */
.reveal { opacity: 0; transform: translateY(24px); transition: opacity 0.6s ease, transform 0.6s ease; }
.reveal.in { opacity: 1; transform: none; }

/* ---------- Responsive ---------- */
@media (max-width: 900px) {
  .about-grid, .edu-grid, .contact-grid { grid-template-columns: 1fr; gap: 32px; }
  .proj-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 760px) {
  .nav-links {
    position: fixed; inset: 0 0 0 auto; width: min(78%, 320px);
    flex-direction: column; align-items: flex-start; gap: 22px;
    background: var(--navy); padding: 100px 32px; transform: translateX(100%);
    transition: transform 0.3s ease; border-left: 1px solid var(--line);
  }
  .nav-links.open { transform: none; }
  .nav-toggle { display: flex; z-index: 110; }
  .nav-toggle.open span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
  .nav-toggle.open span:nth-child(2) { opacity: 0; }
  .nav-toggle.open span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }
  .skills-grid { grid-template-columns: 1fr; }
  .skill-card.wide { grid-column: span 1; }
  .proj-grid { grid-template-columns: 1fr; }
  .contact-form .pair { grid-template-columns: 1fr; }
  .block { padding: 72px 0; }
}

@media (prefers-reduced-motion: reduce) {
  * { animation: none !important; transition: none !important; scroll-behavior: auto !important; }
  .reveal { opacity: 1; transform: none; }
}
ARH_EOF
commit "Add navy and gold design system"

# ----- 3 -----
cat > "$D/js/main.js" <<'ARH_EOF'
// ===== Year =====
document.getElementById("year").textContent = new Date().getFullYear();

// ===== Navbar scrolled state =====
const navbar = document.getElementById("navbar");
const onScroll = () => navbar.classList.toggle("scrolled", window.scrollY > 20);
onScroll();
window.addEventListener("scroll", onScroll, { passive: true });

// ===== Mobile menu =====
const navToggle = document.getElementById("navToggle");
const navLinks = document.getElementById("navLinks");
navToggle.addEventListener("click", () => {
  navLinks.classList.toggle("open");
  navToggle.classList.toggle("open");
});
navLinks.querySelectorAll("a").forEach((a) =>
  a.addEventListener("click", () => {
    navLinks.classList.remove("open");
    navToggle.classList.remove("open");
  })
);

// ===== Scroll reveal =====
const revealObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((e) => {
      if (e.isIntersecting) {
        e.target.classList.add("in");
        revealObserver.unobserve(e.target);
      }
    });
  },
  { threshold: 0.12 }
);
document.querySelectorAll(".reveal").forEach((el) => revealObserver.observe(el));

// ===== Active nav link on scroll =====
const sections = document.querySelectorAll("section[id]");
const linkFor = {};
document.querySelectorAll(".nav-links a").forEach((a) => {
  linkFor[a.getAttribute("href").slice(1)] = a;
});
const spyObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((e) => {
      if (e.isIntersecting) {
        document.querySelectorAll(".nav-links a").forEach((a) => a.classList.remove("active"));
        const link = linkFor[e.target.id];
        if (link) link.classList.add("active");
      }
    });
  },
  { rootMargin: "-45% 0px -50% 0px" }
);
sections.forEach((s) => spyObserver.observe(s));

// ===== Hero rotator =====
const rotator = document.getElementById("rotator");
const roles = ["Quality Assurance", "Cybersecurity", "Test Automation", "Networking"];
let ri = 0;
const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
if (rotator && !reduceMotion) {
  setInterval(() => {
    ri = (ri + 1) % roles.length;
    rotator.style.opacity = "0";
    setTimeout(() => {
      rotator.textContent = roles[ri];
      rotator.style.opacity = "1";
    }, 280);
  }, 2600);
  rotator.style.transition = "opacity 0.28s ease";
}

// ===== Project filter =====
const filterBar = document.getElementById("projFilter");
const cards = document.querySelectorAll("#projGrid .proj-card");
filterBar.addEventListener("click", (e) => {
  const btn = e.target.closest(".chip");
  if (!btn) return;
  filterBar.querySelectorAll(".chip").forEach((c) => c.classList.remove("active"));
  btn.classList.add("active");
  const f = btn.dataset.filter;
  cards.forEach((card) => {
    const cats = card.dataset.cat.split(" ");
    card.style.display = f === "all" || cats.includes(f) ? "flex" : "none";
  });
});

// ===== Contact form: works out of the box via mailto, posts to Formspree once configured =====
const form = document.getElementById("contactForm");
form.addEventListener("submit", (e) => {
  if (form.action.includes("YOUR_FORM_ID")) {
    e.preventDefault();
    const d = new FormData(form);
    const subject = encodeURIComponent(`Portfolio enquiry from ${d.get("name") || ""} ${d.get("surname") || ""}`.trim());
    const body = encodeURIComponent(
      `Name: ${d.get("name") || ""} ${d.get("surname") || ""}\n` +
      `Email: ${d.get("email") || ""}\n` +
      `Mobile: ${d.get("mobile") || ""}\n\n` +
      `${d.get("message") || ""}`
    );
    window.location.href = `mailto:arehonembadaliga@gmail.com?subject=${subject}&body=${body}`;
  }
});
ARH_EOF
commit "Add navigation, scroll reveal and project filter"

# ----- 4 -----
cat > "$D/index.html" <<'ARH_EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Arehone Mbadaliga | QA, Cybersecurity & IT Professional</title>
  <meta name="description" content="Arehone Mbadaliga is a South African IT professional working in QA and automation testing, with a cybersecurity specialisation, networking foundations and a software development background." />
  <meta name="author" content="Arehone Mbadaliga" />

  <meta property="og:title" content="Arehone Mbadaliga | QA, Cybersecurity & IT Professional" />
  <meta property="og:description" content="QA and automation testing, cybersecurity, networking and software development." />
  <meta property="og:type" content="website" />
  <meta property="og:url" content="https://arehoneporto.netlify.app/" />

  <link rel="icon" href="images/logo.jpeg" />

  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" />

  <link rel="stylesheet" href="css/style.css" />
</head>
<body>

  <!-- ============ NAV ============ -->
  <header class="navbar" id="navbar">
    <a href="#home" class="brand">
      <img src="images/logo.jpeg" alt="MbakzArr logo" />
      <span>Arehone Mbadaliga<small>Tech made easy</small></span>
    </a>
    <nav>
      <ul class="nav-links" id="navLinks">
        <li><a href="#home">Home</a></li>
        <li><a href="#about">About</a></li>
        <li><a href="#skills">Skills</a></li>
        <li><a href="#experience">Experience</a></li>
        <li><a href="#projects">Projects</a></li>
        <li><a href="#education">Education</a></li>
        <li><a href="#contact">Contact</a></li>
      </ul>
    </nav>
    <button class="nav-toggle" id="navToggle" aria-label="Open menu">
      <span></span><span></span><span></span>
    </button>
  </header>

ARH_EOF
commit "Build page shell, navigation and SEO meta"

# ----- 5 -----
cat >> "$D/index.html" <<'ARH_EOF'
  <!-- ============ HERO ============ -->
  <section class="hero" id="home">
    <div class="hero-grid" aria-hidden="true"></div>
    <div class="wrap">
      <div class="status reveal">
        <span class="dot"></span> Open to QA, cybersecurity and automation roles
      </div>
      <h1 class="reveal">Hi, I'm Arehone<br /><span class="accent">Mbadaliga.</span></h1>
      <p class="role-line reveal">
        I build and test software for a living. Focus: <span class="rotator" id="rotator">Quality Assurance</span>
      </p>
      <p class="lead reveal">
        I am a South African IT professional working in QA and automation testing, with a cybersecurity
        specialisation, solid networking foundations and a software development background. I care about
        software that is reliable, secure and well tested.
      </p>
      <div class="hero-buttons reveal">
        <a href="#contact" class="btn primary">Hire me</a>
        <a href="#projects" class="btn ghost">View my work</a>
      </div>
      <div class="hero-meta reveal">
        <div><b>3+</b><small>Roles in tech</small></div>
        <div><b>10+</b><small>Hands-on projects</small></div>
        <div><b>15+</b><small>Certifications & badges</small></div>
      </div>
    </div>
  </section>

ARH_EOF
commit "Add hero with availability status and quick stats"

# ----- 6 -----
cat >> "$D/index.html" <<'ARH_EOF'
  <!-- ============ ABOUT ============ -->
  <section class="block" id="about">
    <div class="wrap">
      <span class="eyebrow reveal">// 01 · About</span>
      <h2 class="block-title reveal">A versatile engineer with a tester's eye<br />and a security mindset.</h2>
      <div class="about-grid">
        <div class="about-text reveal">
          <p>
            My work sits where quality, security and reliability meet. Day to day I design and run
            tests for enterprise banking applications at <strong>Wipro Technologies</strong>, supporting the
            Liberty Standard Bank Group, where I cover manual, API and automated testing inside Agile teams.
          </p>
          <p>
            Before that I trained as a <strong>Software Developer and QA / Cybersecurity Trainee at the CSIR</strong>,
            building secure web applications and learning vulnerability assessment from the inside. I am
            currently completing an <strong>Honours BSc in Computer Science with Cybersecurity</strong> at the
            University of Johannesburg.
          </p>
          <p>
            I am honest about where I am strong and where I am still growing. I write clear technical reports,
            I learn fast and I enjoy turning a messy system into something dependable. Right now I am focused
            on QA and automation while I deepen my cybersecurity skills through labs and CTF practice.
          </p>
        </div>
        <aside class="about-card reveal">
          <h4>Quick facts</h4>
          <div class="row"><span>Based in</span><span>Gauteng, South Africa</span></div>
          <div class="row"><span>Current role</span><span>QA / Automation, Wipro</span></div>
          <div class="row"><span>Studying</span><span>Honours CS, Cybersecurity (UJ)</span></div>
          <div class="row"><span>Focus areas</span><span>QA, Security, Automation</span></div>
          <div class="row"><span>Availability</span><span>Open to opportunities</span></div>
        </aside>
      </div>
    </div>
  </section>

ARH_EOF
commit "Add about section and quick facts"

# ----- 7 -----
cat >> "$D/index.html" <<'ARH_EOF'
  <!-- ============ SKILLS ============ -->
  <section class="block" id="skills">
    <div class="wrap">
      <span class="eyebrow reveal">// 02 · Skills</span>
      <h2 class="block-title reveal">What I can do</h2>
      <p class="block-intro reveal">
        Grouped by discipline. Quality assurance and cybersecurity are my core, supported by networking,
        software development and IT operations.
      </p>

      <div class="skills-grid">
        <article class="skill-card reveal">
          <span class="num">01</span>
          <h3>Quality Assurance & Automation</h3>
          <div class="tags">
            <span class="tag">Manual & Functional Testing</span>
            <span class="tag">Test Planning & Case Design</span>
            <span class="tag">Integration & Regression</span>
            <span class="tag">API Testing (Postman)</span>
            <span class="tag">Selenium (Java)</span>
            <span class="tag">Playwright (Java, TestNG)</span>
            <span class="tag">Cucumber BDD</span>
            <span class="tag">JUnit / TestNG</span>
            <span class="tag">JMeter</span>
            <span class="tag">Functionize VAE</span>
            <span class="tag">SQL Data Validation</span>
            <span class="tag">Defect Management</span>
            <span class="tag">Azure DevOps</span>
            <span class="tag">Agile / Scrum / SDLC</span>
          </div>
        </article>

        <article class="skill-card reveal">
          <span class="num">02</span>
          <h3>Cybersecurity</h3>
          <div class="tags">
            <span class="tag">Vulnerability Assessment</span>
            <span class="tag">Web App Security (OWASP Top 10)</span>
            <span class="tag">Penetration Testing (fundamentals)</span>
            <span class="tag">Burp Suite</span>
            <span class="tag">Nmap</span>
            <span class="tag">Metasploit</span>
            <span class="tag">Wireshark</span>
            <span class="tag">Kali Linux</span>
            <span class="tag">SIEM (Splunk, ELK, Graylog)</span>
            <span class="tag">Secure Coding Practices</span>
            <span class="tag">Security Reporting</span>
          </div>
        </article>

        <article class="skill-card reveal">
          <span class="num">03</span>
          <h3>Networking</h3>
          <div class="tags">
            <span class="tag">TCP/IP</span>
            <span class="tag">DNS & DHCP</span>
            <span class="tag">Routing & Switching</span>
            <span class="tag">VLANs</span>
            <span class="tag">OSPF</span>
            <span class="tag">IPv6 Configuration</span>
            <span class="tag">Cisco Packet Tracer</span>
            <span class="tag">Firewalls (fundamentals)</span>
            <span class="tag">Network Troubleshooting</span>
          </div>
        </article>

        <article class="skill-card reveal">
          <span class="num">04</span>
          <h3>Software Development</h3>
          <div class="tags">
            <span class="tag">Java (Spring Boot)</span>
            <span class="tag">PHP (Laravel)</span>
            <span class="tag">Python</span>
            <span class="tag">REST APIs</span>
            <span class="tag">SQL / MySQL</span>
            <span class="tag">HTML, CSS, JavaScript</span>
            <span class="tag">Git & GitHub</span>
          </div>
        </article>

        <article class="skill-card wide reveal">
          <span class="num">05</span>
          <h3>IT Operations</h3>
          <div class="tags">
            <span class="tag">Windows & Linux Administration</span>
            <span class="tag">OS Installation & Troubleshooting</span>
            <span class="tag">End-user & Desktop Support</span>
            <span class="tag">Hardware Maintenance</span>
            <span class="tag">Virtualisation (VMware, VirtualBox)</span>
            <span class="tag">ITIL V4 (fundamentals)</span>
            <span class="tag">Microsoft 365</span>
            <span class="tag">Technical Writing</span>
          </div>
        </article>
      </div>
    </div>
  </section>

ARH_EOF
commit "Add grouped skills (QA, security, networking, dev, IT ops)"

# ----- 8 -----
cat >> "$D/index.html" <<'ARH_EOF'
  <!-- ============ EXPERIENCE ============ -->
  <section class="block" id="experience">
    <div class="wrap">
      <span class="eyebrow reveal">// 03 · Experience</span>
      <h2 class="block-title reveal">Where I have worked</h2>

      <div class="timeline">
        <div class="tl-item now reveal">
          <div class="tl-date">Mar 2025 to Present · Johannesburg</div>
          <h3>QA and Automation Testing</h3>
          <div class="tl-org">Wipro Technologies (Liberty Standard Bank Group)</div>
          <ul>
            <li>Design and run manual, functional, integration and regression tests for enterprise banking applications.</li>
            <li>Build and maintain automated test scripts using Selenium and Playwright with Java and TestNG.</li>
            <li>Perform API testing with Postman and validate data using SQL.</li>
            <li>Log, track and manage defects in Azure DevOps within Agile delivery teams.</li>
            <li>Work with developers and business analysts to support reliable, on-time releases.</li>
          </ul>
        </div>

        <div class="tl-item reveal">
          <div class="tl-date">Sep 2024 to Feb 2025 · Pretoria</div>
          <h3>Software Developer & QA / Cybersecurity Trainee</h3>
          <div class="tl-org">Council for Scientific and Industrial Research (CSIR)</div>
          <ul>
            <li>Developed and tested secure web applications using Spring Boot and Laravel.</li>
            <li>Carried out manual and API testing and supported vulnerability assessment on internal systems.</li>
            <li>Applied secure coding practices and documented findings in clear technical reports.</li>
            <li>Presented results and recommendations to project stakeholders.</li>
          </ul>
        </div>

        <div class="tl-item reveal">
          <div class="tl-date">Feb 2024 to Jun 2024 · Polokwane</div>
          <h3>Computer Lab Assistant (IT Support)</h3>
          <div class="tl-org">University of Limpopo, ICT</div>
          <ul>
            <li>Provided desktop and infrastructure support to over 200 users.</li>
            <li>Installed and configured Linux and Windows systems, software and network connectivity.</li>
            <li>Diagnosed and resolved hardware, software and network issues, improving lab efficiency by 20%.</li>
          </ul>
        </div>

        <div class="tl-item reveal">
          <div class="tl-date">Jul 2022 to Jun 2024 · University of Limpopo</div>
          <h3>Co-Founder & Technician</h3>
          <div class="tl-org">University of Limpopo Developers Society</div>
          <ul>
            <li>Mentored students in software development and cybersecurity fundamentals.</li>
            <li>Organised technical workshops and industry engagement events.</li>
          </ul>
        </div>

        <div class="tl-item reveal">
          <div class="tl-date">Jul 2022 to Dec 2022 · National</div>
          <h3>Student Cluster Competition Competitor</h3>
          <div class="tl-org">NICIS CHPC</div>
          <ul>
            <li>Worked in a high-performance computing team managing Linux systems, networking and server optimisation.</li>
            <li>Collaborated under tight deadlines to improve system performance and reliability.</li>
          </ul>
        </div>
      </div>
    </div>
  </section>

ARH_EOF
commit "Add experience timeline"

# ----- 9 -----
cat >> "$D/index.html" <<'ARH_EOF'
  <!-- ============ PROJECTS ============ -->
  <section class="block" id="projects">
    <div class="wrap">
      <span class="eyebrow reveal">// 04 · Projects</span>
      <h2 class="block-title reveal">Things I have built</h2>
      <p class="block-intro reveal">Filter by area to see how the pieces fit together.</p>

      <div class="proj-filter reveal" id="projFilter">
        <button class="chip active" data-filter="all">All</button>
        <button class="chip" data-filter="security">Cybersecurity</button>
        <button class="chip" data-filter="qa">Quality Assurance</button>
        <button class="chip" data-filter="dev">Software Dev</button>
        <button class="chip" data-filter="network">Networking</button>
      </div>

      <div class="proj-grid" id="projGrid">
        <article class="proj-card reveal" data-cat="security">
          <div class="proj-cat">Cybersecurity</div>
          <h3>Web Application Firewall</h3>
          <p>A WAF combining rule-based filtering with a lightweight machine learning model to flag suspicious traffic and common web attacks.</p>
          <div class="proj-stack"><span>Python</span><span>ML</span><span>Security</span></div>
          <div class="proj-links"><a href="https://github.com/MbakzArr" target="_blank" rel="noopener">View code &rarr;</a></div> <!-- TODO: replace with this project's repo URL -->
        </article>

        <article class="proj-card reveal" data-cat="security">
          <div class="proj-cat">Cybersecurity</div>
          <h3>Web App Penetration Testing Lab</h3>
          <p>Hands-on testing of DVWA and OWASP Juice Shop, identifying OWASP Top 10 issues like XSS and SQL injection and writing structured reports with remediation steps.</p>
          <div class="proj-stack"><span>Burp Suite</span><span>Kali Linux</span><span>OWASP</span></div>
          <div class="proj-links"><a href="https://github.com/MbakzArr" target="_blank" rel="noopener">View code &rarr;</a></div> <!-- TODO: replace with this project's repo URL -->
        </article>

        <article class="proj-card reveal" data-cat="security">
          <div class="proj-cat">Cybersecurity</div>
          <h3>SIEM Monitoring Labs</h3>
          <p>Built logging and detection labs using the ELK Stack and Splunk to ingest events, search logs and surface signs of intrusion.</p>
          <div class="proj-stack"><span>ELK Stack</span><span>Splunk</span><span>Log Analysis</span></div>
          <div class="proj-links"><a href="https://github.com/MbakzArr" target="_blank" rel="noopener">View code &rarr;</a></div> <!-- TODO: replace with this project's repo URL -->
        </article>

        <article class="proj-card reveal" data-cat="qa">
          <div class="proj-cat">Quality Assurance</div>
          <h3>OrangeHRM Automation Suite</h3>
          <p>End-to-end UI automation for the OrangeHRM platform, with reusable test components and reporting using Playwright and Java.</p>
          <div class="proj-stack"><span>Playwright</span><span>Java</span><span>TestNG</span></div>
          <div class="proj-links"><a href="https://github.com/MbakzArr" target="_blank" rel="noopener">View code &rarr;</a></div> <!-- TODO: replace with this project's repo URL -->
        </article>

        <article class="proj-card reveal" data-cat="dev qa">
          <div class="proj-cat">Software Dev · QA</div>
          <h3>Student Purchasing System</h3>
          <p>A Spring Boot REST application for student merchandise orders, with full CRUD, manual and API test cases and SQL data validation.</p>
          <div class="proj-stack"><span>Spring Boot</span><span>REST API</span><span>SQL</span></div>
          <div class="proj-links"><a href="https://github.com/MbakzArr" target="_blank" rel="noopener">View code &rarr;</a></div> <!-- TODO: replace with this project's repo URL -->
        </article>

        <article class="proj-card reveal" data-cat="dev qa">
          <div class="proj-cat">Software Dev · QA</div>
          <h3>Hospital Management System</h3>
          <p>A Laravel web app for patient, doctor and medication workflows, with role-based access plus functional and integration testing.</p>
          <div class="proj-stack"><span>Laravel</span><span>PHP</span><span>MySQL</span></div>
          <div class="proj-links"><a href="https://github.com/MbakzArr" target="_blank" rel="noopener">View code &rarr;</a></div> <!-- TODO: replace with this project's repo URL -->
        </article>

        <article class="proj-card reveal" data-cat="dev">
          <div class="proj-cat">Software Dev</div>
          <h3>Tshivenda Language Bot</h3>
          <p>A Python chatbot that delivers translation, quizzes and news in Tshivenda. An ongoing personal project that keeps growing.</p>
          <div class="proj-stack"><span>Python</span><span>NLP</span><span>Bot</span></div>
          <div class="proj-links"><a href="https://github.com/MbakzArr" target="_blank" rel="noopener">View code &rarr;</a></div> <!-- TODO: replace with this project's repo URL -->
        </article>

        <article class="proj-card reveal" data-cat="network">
          <div class="proj-cat">Networking</div>
          <h3>Network Configuration Labs</h3>
          <p>Designed and tested multi-subnet networks in Cisco Packet Tracer, covering VLANs, OSPFv2 routing and IPv6 with DHCPv6.</p>
          <div class="proj-stack"><span>Cisco Packet Tracer</span><span>VLAN</span><span>OSPF</span></div>
          <div class="proj-links"><a href="https://github.com/MbakzArr" target="_blank" rel="noopener">View code &rarr;</a></div> <!-- TODO: replace with this project's repo URL -->
        </article>
      </div>
    </div>
  </section>

ARH_EOF
commit "Add projects with GitHub links"

# ----- 10 -----
cat >> "$D/index.html" <<'ARH_EOF'
  <!-- ============ EDUCATION + CERTS ============ -->
  <section class="block" id="education">
    <div class="wrap">
      <span class="eyebrow reveal">// 05 · Education & Certifications</span>
      <h2 class="block-title reveal">How I keep learning</h2>

      <div class="edu-grid">
        <div class="reveal">
          <div class="edu-item">
            <h3>Certificate in Information Technology Concepts</h3>
            <div class="school">Okanagan College</div>
            <div class="when">Jan 2026 to Present</div>
            <p class="desc">A well-rounded foundation across the essential areas of IT, covering networking fundamentals, cybersecurity principles and local area network management through a mix of theory and interactive labs, building the skills to install, configure, troubleshoot and maintain IT systems.</p>
            <div class="sponsor">Sponsored by SouthernLabs Institute of Technology</div>
          </div>
          <div class="edu-item">
            <h3>Honours BSc, Computer Science with Cybersecurity</h3>
            <div class="school">University of Johannesburg</div>
            <div class="when">2025 to Present</div>
          </div>
          <div class="edu-item">
            <h3>BSc, Mathematical and Computer Science</h3>
            <div class="school">University of Limpopo · Majors: Computer Science and Physics</div>
            <div class="when">2019 to 2024</div>
          </div>
          <div class="edu-item">
            <h3>Certificate in Applied Software Development</h3>
            <div class="school">Mohawk College</div>
            <div class="when">2024 to 2025</div>
            <p class="desc">A comprehensive foundation in the programming and technical skills needed in software development, with hands-on work across Python fundamentals, Java development, object-oriented programming, microcontroller programming in C and database theory with SQL.</p>
            <div class="sponsor">Sponsored by SouthernLabs Institute of Technology</div>
          </div>
          <div class="edu-item">
            <h3>Certificate in Cybersecurity Operations</h3>
            <div class="school">British Columbia Institute of Technology</div>
            <div class="when">2022 to 2023</div>
            <div class="sponsor">Sponsored by SouthernLabs Institute of Technology</div>
          </div>
        </div>

        <div class="cert-list reveal">
          <div class="cert"><span class="ic">A+</span><b>CompTIA A+ ce</b><span class="meta">2024 to 2027</span></div>
          <div class="cert"><span class="ic">&gt;_</span><b>Cisco CyberOps Associate</b><span class="meta">Cisco</span></div>
          <div class="cert"><span class="ic">&gt;_</span><b>Cybersecurity Fundamentals</b><span class="meta">IBM</span></div>
          <div class="cert"><span class="ic">&gt;_</span><b>Information Technology Fundamentals</b><span class="meta">IBM</span></div>
          <div class="cert"><span class="ic">&gt;_</span><b>Networking Devices & Initial Configuration</b><span class="meta">Cisco</span></div>
          <div class="cert"><span class="ic">&gt;_</span><b>Introduction to ITIL V4</b><span class="meta">Simplilearn</span></div>
          <div class="cert"><span class="ic">&gt;_</span><b>Technical Writing</b><span class="meta">BCIT</span></div>
          <div class="cert"><span class="ic">⋯</span><b>ISTQB Foundation Level</b><span class="meta">In progress</span></div>
        </div>
      </div>
    </div>
  </section>

ARH_EOF
commit "Add education and certifications"

# ----- 11 -----
cat >> "$D/index.html" <<'ARH_EOF'
  <!-- ============ CONTACT ============ -->
  <section class="block contact" id="contact">
    <div class="wrap">
      <span class="eyebrow reveal">// 06 · Contact</span>
      <h2 class="block-title reveal">Let's work together</h2>
      <p class="block-intro reveal">
        I am open to QA, cybersecurity and automation roles. The fastest way to reach me is email or WhatsApp.
      </p>

      <div class="contact-grid">
        <div class="contact-links reveal">
          <a class="clink" href="mailto:arehonembadaliga@gmail.com">
            <span class="ic">@</span><span><small>Email</small><b>arehonembadaliga@gmail.com</b></span>
          </a>
          <a class="clink" href="tel:+27761714986">
            <span class="ic">☎</span><span><small>Phone</small><b>+27 76 171 4986</b></span>
          </a>
          <a class="clink" href="https://wa.me/27761714986" target="_blank" rel="noopener">
            <span class="ic">W</span><span><small>WhatsApp</small><b>Message me</b></span>
          </a>
          <a class="clink" href="https://www.linkedin.com/in/arehone-mbadaliga-b8b795210" target="_blank" rel="noopener">
            <span class="ic">in</span><span><small>LinkedIn</small><b>arehone-mbadaliga</b></span>
          </a>
          <a class="clink" href="https://github.com/MbakzArr" target="_blank" rel="noopener">
            <span class="ic">&lt;/&gt;</span><span><small>GitHub</small><b>MbakzArr</b></span>
          </a>
        </div>

        <form class="contact-form reveal" id="contactForm" action="https://formspree.io/f/YOUR_FORM_ID" method="POST">
          <div class="pair">
            <input type="text" name="name" placeholder="Name" required />
            <input type="text" name="surname" placeholder="Surname" required />
          </div>
          <div class="pair">
            <input type="email" name="email" placeholder="Email" required />
            <input type="text" name="mobile" placeholder="Mobile number" />
          </div>
          <textarea name="message" placeholder="Tell me about the role or project" required></textarea>
          <button type="submit" class="btn primary">Send message</button>
          <p class="form-note">
            This form opens your email app by default so it works right away. To collect messages
            automatically, create a free form at formspree.io and replace YOUR_FORM_ID in the code.
          </p>
        </form>
      </div>
    </div>
  </section>

  <!-- ============ FOOTER ============ -->
  <footer>
    <div class="wrap">
      <p>&copy; <span id="year"></span> Arehone Mbadaliga. Built and maintained by me.</p>
      <div class="socials">
        <a href="https://github.com/MbakzArr" target="_blank" rel="noopener">GitHub</a>
        <a href="https://www.linkedin.com/in/arehone-mbadaliga-b8b795210" target="_blank" rel="noopener">LinkedIn</a>
        <a href="mailto:arehonembadaliga@gmail.com">Email</a>
      </div>
    </div>
  </footer>

  <script src="js/main.js"></script>
</body>
</html>
ARH_EOF
commit "Add contact section and footer"

# ----- 12 -----
cat > "$D/_redirects" <<'ARH_EOF'
/about        /#about        301
/experience   /#experience   301
/projects     /#projects     301
/projetcs     /#projects     301
/education    /#education     301
/contact      /#contact      301
ARH_EOF
commit "Add Netlify redirects for old page URLs"

# ----- 13 -----
cat > README.md <<'ARH_EOF'
# Arehone Mbadaliga - Portfolio

Personal portfolio of Arehone Mbadaliga, an IT professional working in QA and automation
testing, with a cybersecurity specialisation, networking foundations and a software
development background.

Live site: https://arehoneporto.netlify.app

## Sections

- Hero with current availability
- About and quick facts
- Skills grouped into Quality Assurance, Cybersecurity, Networking, Software Development and IT Operations
- Experience timeline
- Projects with links to source code
- Education and certifications
- Contact

## Built with

- HTML, CSS and vanilla JavaScript
- Google Fonts: Space Grotesk, Inter, JetBrains Mono
- Hosted on Netlify

## Structure

    MyPortofolio/
      index.html        single page
      css/style.css     styles and design tokens
      js/main.js        navigation, scroll reveal, project filter
      images/           logo and assets
      _redirects        Netlify redirects for old page URLs

## Deploy

Netlify publishes from the MyPortofolio folder. Pushing to the default branch
triggers an automatic redeploy.
ARH_EOF
commit "Update README"

echo ""
echo "Done. 13 commits created. Review in VS Code, then run:  git push"
