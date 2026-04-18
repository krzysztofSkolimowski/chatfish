// @ts-check
import { defineConfig, devices } from "@playwright/test";

const BASE_URL = process.env.BASE_URL || "http://localhost:8080";

export default defineConfig({
  testDir: "./tests",
  timeout: 30_000,
  retries: 0,
  reporter: "list",

  webServer: {
    // Quartz dev server — builds then serves on port 8080
    command: "npx quartz build -d ../wiki --serve",
    url: BASE_URL,
    reuseExistingServer: !!process.env.BASE_URL,
    timeout: 120_000,
  },

  use: {
    baseURL: BASE_URL,
    ...devices["Desktop Chrome"],
  },
});
