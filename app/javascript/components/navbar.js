const initUpdateNavbarOnScroll = () => {
    const navbar = document.querySelector(".navbar-lewagon");
    if (navbar) {
        window.addEventListener("scroll", () => {
            if (window.scrollY >= window.innerHeight - 50) {
                navbar.classList.add("bg-dark");
                navbar.classList.add("shadow");
            } else {
                navbar.classList.remove("bg-dark");
                navbar.classList.remove("shadow");
            }
        });
    }
};

export { initUpdateNavbarOnScroll };