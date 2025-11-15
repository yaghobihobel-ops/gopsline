# PHP 8 Upgrade Roadmap

This document outlines the strategy and steps required to upgrade the application to PHP 8.

## 1. Environment Setup

1.  **Create a dedicated development branch:** All work should be done in a separate Git branch to avoid disrupting the main codebase.
2.  **Set up a local development environment with PHP 8:** Use Docker or a similar tool to create an environment that mirrors the production server but with PHP 8.

## 2. Dependency Management

1.  **Create a root `composer.json` file:** The project currently lacks a centralized dependency management system. A root `composer.json` file should be created to manage all PHP dependencies.
2.  **Add all identified dependencies to `composer.json`:** This includes `phpoffice/phpspreadsheet`, `intervention/image`, `firebase/php-jwt`, `dompdf/dompdf`, and `chillerlan/php-qrcode`.
3.  **Install dependencies with Composer:** Run `composer install` to download and install all dependencies.

## 3. Code Refactoring

1.  **Address `preg_replace` `/e` modifier:**
    *   Locate all instances of `preg_replace` with the `/e` modifier.
    *   Replace them with `preg_replace_callback`.
2.  **Replace `ereg` functions:**
    *   Identify all calls to `ereg` and `eregi`.
    *   Replace them with `preg_match`.
3.  **Replace `mcrypt` functions:**
    *   Find all `mcrypt_*` function calls.
    *   Replace them with the equivalent `openssl_*` functions. This may require careful analysis of the encryption logic.
4.  **Address other deprecated functions:**
    *   Replace `get_magic_quotes_gpc` with appropriate input filtering.
    *   Replace `Each` with `foreach` loops.
    *   Address the use of `$this` in non-class contexts.
    *   Replace the `cpdf` extension with `pecl/pdflib`.

## 4. Jalali (Shamsi) Calendar Implementation

The current implementation of the Jalali calendar is incomplete. A comprehensive solution requires the following steps:

1.  **Backend:**
    *   **Install a dedicated library:** Use a library like `morilog/jalali` to handle date and time conversions.
    *   **Create a helper class:** Develop a helper class that wraps the Jalali library and provides a consistent interface for converting dates and times between Gregorian and Jalali.
    *   **Update the application:** Replace all instances of date and time formatting with calls to the new helper class.

2.  **Frontend:**
    *   **Install a date/time library:** Use a library like `moment-jalaali` to handle date and time formatting in the Vue.js frontend.
    *   **Create a global mixin:** Develop a global Vue mixin that provides methods for formatting dates and times in the Jalali calendar.
    *   **Update components:** Replace all instances of date and time formatting with calls to the new mixin.

## 5. Testing

1.  **Set up a testing framework:** If one is not already in place, configure PHPUnit for unit and integration testing.
2.  **Write tests for critical functionality:** Create tests for user authentication, order processing, payment integration, and other core features.
3.  **Perform comprehensive testing:**
    *   Run all existing tests (if any).
    *   Run the newly created tests.
    *   Manually test all user flows to identify any regressions.

## 5. Deployment

1.  **Deploy to a staging environment:** Before deploying to production, deploy the upgraded application to a staging server that mirrors the production environment.
2.  **Perform final testing on staging:** Conduct a final round of testing on the staging server to ensure everything is working as expected.
3.  **Deploy to production:** Once the staging deployment is verified, deploy the application to the production server.
