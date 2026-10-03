import type { MetadataRoute } from "next";

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: "*",
        allow: "/",
        disallow: ["/dashboard/", "/api/", "/auth/callback"],
      },
    ],
    sitemap: "https://nova-academy.ir/sitemap.xml",
  };
}
