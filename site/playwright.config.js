// @ts-check
const { defineConfig, devices } = require("@playwright/test");

const BASE_URL = process.env.BASE_URL || "http://localhost:1313";

module.exports = defineConfig({
  testDir: "./tests",
  timeout: 30_000,
  retries: 0,
  reporter: "list",

  webServer: {
    // Hugo dev server — only used locally, CI pre-builds and serves separately
    command: "hugo server --port 1313 --disableFastRender",
    url: BASE_URL,
    reuseExistingServer: !!process.env.BASE_URL,
    timeout: 60_000,
  },

  use: {
    baseURL: BASE_URL,
    ...devices["Desktop Chrome"],
  },
});
