import type { MetadataRoute } from "next";
import { createClient } from "@/lib/supabase/server";

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const baseUrl = "https://nova-academy.ir";

  const staticRoutes: MetadataRoute.Sitemap = [
    {
      url: baseUrl,
      lastModified: new Date(),
      changeFrequency: "daily",
      priority: 1.0,
    },
    {
      url: `${baseUrl}/mag`,
      lastModified: new Date(),
      changeFrequency: "daily",
      priority: 0.9,
    },
    {
      url: `${baseUrl}/auth/sign-in`,
      lastModified: new Date(),
      changeFrequency: "monthly",
      priority: 0.5,
    },
    {
      url: `${baseUrl}/auth/sign-up`,
      lastModified: new Date(),
      changeFrequency: "monthly",
      priority: 0.5,
    },
  ];

  try {
    const supabase = await createClient();
    const { data: resources } = await supabase
      .from("resources")
      .select("id, published_at")
      .eq("status", "published");

    if (resources && resources.length > 0) {
      const dynamicRoutes: MetadataRoute.Sitemap = resources.map((r) => ({
        url: `${baseUrl}/mag/${r.id}`,
        lastModified: r.published_at ? new Date(r.published_at) : new Date(),
        changeFrequency: "weekly",
        priority: 0.8,
      }));
      return [...staticRoutes, ...dynamicRoutes];
    }
  } catch {
    // fallback to static routes
  }

  return staticRoutes;
}
