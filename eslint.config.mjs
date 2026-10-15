import { FlatCompat } from "@eslint/eslintrc";
import { dirname } from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const compat = new FlatCompat({ baseDirectory: __dirname });

const config = [
  { ignores: [".next/**", "next-env.d.ts", "public/pdfjs/**"] },
  ...compat.extends("next/core-web-vitals", "next/typescript"),
  // Node test/build tools intentionally use CommonJS; application rules stay strict.
  { files: ["scripts/**/*.cjs", "tests/**/*.cjs"], rules: { "@typescript-eslint/no-require-imports": "off" } },
];

export default config;
