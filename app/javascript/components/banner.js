import Typed from "typed.js";

const dynamicText = () => {
	new Typed("#typed-text", {
		strings: [
			"The best cocktails on the internet",
			"Discover new drinks",
			"Share with friends",
			"Mix your own",
			"Created at Le Wagon",
			"Drink cachaça, carai!!!",
		],
		typeSpeed: 50,
		loop: true,
	});
};

export { dynamicText };
