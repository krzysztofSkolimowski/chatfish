// @ts-check
const { test, expect } = require("@playwright/test");

test("homepage loads", async ({ page }) => {
  await page.goto("/");
  await expect(page).toHaveTitle(/Chatfish/i);
});

test("homepage has navigation", async ({ page }) => {
  await page.goto("/");
  // Book theme renders a sidebar nav
  const nav = page.locator("nav, aside");
  await expect(nav.first()).toBeVisible();
});

test("docs section loads", async ({ page }) => {
  const response = await page.goto("/docs/");
  expect(response?.status()).toBeLessThan(400);
});

test("mockups section loads", async ({ page }) => {
  const response = await page.goto("/mockups/");
  expect(response?.status()).toBeLessThan(400);
});

test("no broken internal links on homepage", async ({ page }) => {
  await page.goto("/");
  const links = await page.locator("a[href^='/']").all();
  for (const link of links) {
    const href = await link.getAttribute("href");
    if (!href || href.startsWith("/#")) continue;
    const response = await page.request.get(href);
    expect(
      response.status(),
      `Broken link: ${href}`
    ).toBeLessThan(400);
  }
});
