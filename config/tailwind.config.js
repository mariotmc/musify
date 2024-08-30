const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./app/models/**/*.rb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*",
    "./app/components/**/*.rb",
    "./app/components/**/*.html.erb",
    "./app/pages/**/*.rb",
    "./app/pages/**/*.html.erb",
    "./tailwind_dynamic_classes.txt",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
