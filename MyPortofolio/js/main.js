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
