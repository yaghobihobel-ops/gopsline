const routes = [
  {
    path: "/",
    component: () => import("layouts/MainLayout.vue"),
    children: [
      {
        path: "/",
        component: () => import("pages/IndexPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        name: "current",
        path: "/current",
        component: () => import("pages/IndexPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        name: "settings",
        path: "/settings",
        component: () => import("pages/SettingPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        name: "history",
        path: "/history",
        component: () => import("pages/HistoryPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        name: "scheduled",
        path: "/scheduled",
        component: () => import("pages/ScheduledPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        name: "notification",
        path: "/notification-list",
        component: () => import("pages/NotificationList.vue"),
        meta: { requiresAuth: true },
      },
      {
        name: "test",
        path: "/test",
        component: () => import("pages/TestPage.vue"),
        meta: { requiresAuth: true },
      },

      {
        name: "page",
        path: "page/:page_id",
        props: true,
        component: () => import("src/pages/PageRender.vue"),
      },
    ],
  },
  {
    path: "/login",
    component: () => import("layouts/LoginLayout.vue"),
    children: [
      {
        name: "login",
        path: "",
        component: () => import("pages/LoginPage.vue"),
        //component: () => import("pages/TestPage.vue"),
        //component: () => import("pages/TestPrinter.vue"),
        //component: () => import("pages/PrinterAdd.vue"),
      },
    ],
  },

  {
    path: "/forgot-password",
    component: () => import("layouts/LoginLayout.vue"),
    children: [
      {
        name: "forgot-password",
        path: "",
        component: () => import("pages/ForgotPassword.vue"),
      },
    ],
  },

  {
    path: "/delete-account",
    component: () => import("layouts/LoginLayout.vue"),
    children: [
      {
        name: "delete-account",
        path: "",
        component: () => import("pages/DeleteAccount.vue"),
      },
    ],
  },

  {
    path: "/settings-mobile",
    component: () => import("layouts/LoginLayout.vue"),
    children: [
      // {
      //   name: "settings-mobile",
      //   path: "",
      //   component: () => import("pages/SettingMenu.vue"),
      // },
      {
        path: "display",
        component: () => import("pages/DisplayMode.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "sounds",
        component: () => import("pages/SoundSettings.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "transtition-times",
        component: () => import("pages/TransitionTimes.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "colors",
        component: () => import("pages/ColorsSettings.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "language",
        component: () => import("pages/LanguageSettings.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "delete-account",
        component: () => import("pages/DeletesAccount.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "legal",
        component: () => import("pages/LegalPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "printers",
        component: () => import("pages/PrinterList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "printer-add",
        component: () => import("pages/PrinterAdd.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "printer-edit",
        component: () => import("pages/PrinterAdd.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: "/:catchAll(.*)*",
    component: () => import("pages/ErrorNotFound.vue"),
  },
];

export default routes;
