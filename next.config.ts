import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  poweredByHeader: false,
  async headers() {
    return [{
      // Email previews run on another origin. Only this public font is shared;
      // authentication routes and API responses keep their existing policy.
      source: "/fonts/estedad-arabic-wght-normal.woff2",
      headers: [
        { key: "Access-Control-Allow-Origin", value: "*" },
        { key: "Content-Type", value: "font/woff2" },
        { key: "Cache-Control", value: "public, max-age=86400" },
      ],
    }];
  },
  experimental: { serverActions: { bodySizeLimit: "6mb" } },
};

export default nextConfig;
