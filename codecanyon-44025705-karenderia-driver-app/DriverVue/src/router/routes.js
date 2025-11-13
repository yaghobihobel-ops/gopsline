const routes = [
  {
    path: "/",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/User/IntroPage.vue"),
        meta: { checkAuthLogin: true },
      },
      {
        path: "select-language",
        component: () => import("src/pages/User/SelectLanguage.vue"),
      },
      {
        path: "selectzone",
        component: () => import("src/pages/Account/SelectZone.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/user",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "login",
        component: () => import("src/pages/User/LoginPage.vue"),
        meta: { checkAuthLogin: true },
      },
      {
        path: "forgotpass",
        component: () => import("src/pages/User/ForgotPassword.vue"),
      },
      {
        path: "signup",
        component: () => import("src/pages/User/SignupPage.vue"),
      },
    ],
  },

  {
    path: "/account",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "verify",
        component: () => import("src/pages/Account/VerifyCode.vue"),
      },
      {
        path: "attach_license",
        component: () => import("src/pages/Account/AttachLicense.vue"),
      },
      {
        path: "attach_license_photo",
        component: () => import("src/pages/Account/AttachLicensephoto.vue"),
      },
      {
        path: "verified_ty",
        component: () => import("src/pages/Account/VerifiedPage.vue"),
      },
      {
        path: "signup_ty",
        component: () => import("src/pages/Account/SignupTy.vue"),
      },
      {
        path: "schedule",
        component: () => import("src/pages/Account/ScheduleList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "earning-details",
        name: "earning-details",
        component: () => import("src/pages/Account/EarningDetails.vue"),
      },
      {
        path: "earning-activity",
        name: "earning-activity",
        component: () => import("src/pages/Account/EarningActivity.vue"),
      },
      {
        path: "cashout",
        component: () => import("src/pages/Account/CashoutPage.vue"),
      },
      {
        path: "cashout-history",
        component: () => import("src/pages/Account/CashoutHistory.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "cashout-succesful",
        component: () => import("src/pages/Account/CashoutSuccesful.vue"),
      },
      {
        path: "add-bank",
        component: () => import("src/pages/Account/BankAccountcreate.vue"),
      },
      {
        path: "settings",
        component: () => import("src/pages/Account/SettingsPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "profile",
        component: () => import("src/pages/Account/ProfilePage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "edit-profile",
        component: () => import("src/pages/Account/EditProfile.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "bankinfo",
        component: () => import("src/pages/Account/BankInfo.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "payments",
        component: () => import("src/pages/Account/PaymentsList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "payment-add",
        component: () => import("src/pages/Account/PaymentAdd.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "documents",
        component: () => import("src/pages/Account/DocumentsPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "vehicle",
        component: () => import("src/pages/Account/VehiclePage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "license-photo",
        component: () => import("src/pages/Account/TakeLicensePhoto.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "change-password",
        component: () => import("src/pages/Account/ChangePassword.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "reviews",
        component: () => import("src/pages/Account/ReviewsList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "notifications",
        component: () => import("src/pages/Account/NotificationsPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "delete",
        component: () => import("src/pages/Account/DeleteAccount.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "deletety",
        component: () => import("src/pages/Account/DeleteTy.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "cashin",
        component: () => import("src/pages/Account/CashIn.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "cashin-successful",
        component: () => import("src/pages/Account/CashinSuccessful.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "chat",
        component: () => import("src/pages/Chat/ChatMain.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/home",
    component: () => import("layouts/MainLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/Home/ShiftStatus.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "deliveries",
        component: () => import("src/pages/Home/DeliveriesPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "maps",
        component: () => import("src/pages/Home/MapsPage.vue"),
        meta: { requiresAuth: true, requiresLocation: true },
      },
      {
        path: "history",
        component: () => import("src/pages/Home/OrderHistory.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "wallet",
        component: () => import("src/pages/Home/WalletHistory.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "settings",
        component: () => import("src/pages/Account/SettingsPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "schedule",
        component: () => import("src/pages/Account/ScheduleList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "find_schedule",
        component: () => import("src/pages/shift/FindShift.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "earning",
        component: () => import("src/pages/Account/EarningsDashboard.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "notifications",
        component: () => import("src/pages/Account/ScheduleList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "support",
        component: () => import("src/pages/Home/SupportPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "privacy-policy",
        component: () => import("src/pages/Home/PrivacyPolicy.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "legal",
        component: () => import("src/pages/Home/LegalMenu.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/shift",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "find",
        component: () => import("src/pages/shift/FindShift.vue"),
        meta: { requiresAuth: true },
      },
      {
        name: "request_break",
        path: "request-break",
        component: () => import("src/pages/shift/RequestBreak.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/order",
    component: () => import("layouts/NotopnavLayout.vue"),
    children: [
      {
        path: "new",
        component: () => import("src/pages/Order/NewOrder.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "404",
        component: () => import("src/pages/Order/OrderNotfound.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/settings",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "language",
        component: () => import("src/pages/Settings/LanguageSelection.vue"),
        //meta: { requiresAuth: true },
      },
      {
        path: "notifications",
        component: () => import("src/pages/Account/NotificationsPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "legal",
        component: () => import("src/pages/Account/LegalPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        name: "page",
        path: "page/:page_id",
        props: true,
        component: () => import("src/pages/Settings/PageRender.vue"),
      },
    ],
  },

  {
    path: "/location",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "permission",
        component: () => import("src/pages/Location/LocationPermission.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/page",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "privacy-policy",
        component: () => import("src/pages/Page/PrivacyPolicy.vue"),
      },
      {
        path: "support",
        component: () => import("src/pages/Page/SupportPage.vue"),
      },
    ],
  },

  {
    path: "/help",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/Help/HelpMenu.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/chat",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/Chat/ChatConversation.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/errornetwork",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/Help/NetworkError.vue"),
      },
    ],
  },

  {
    path: "/:catchAll(.*)*",
    component: () => import("src/pages/page/ErrorNotFound.vue"),
  },
];
export default routes;
