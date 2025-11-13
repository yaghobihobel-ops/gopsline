const routes = [
  {
    path: "",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("pages/IntroPage.vue"),
        //meta: { checkAuthLogin: true },
      },
      {
        path: "select-language",
        component: () => import("pages/SelectLanguage.vue"),
      },
      {
        path: "access-denied",
        component: () => import("pages/AccessDenied.vue"),
      },
    ],
  },

  {
    path: "/login",
    component: () => import("layouts/LoginLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("pages/LoginPage.vue"),
        meta: { checkAuthLogin: true },
      },
    ],
  },

  {
    path: "/forgotpassword",
    component: () => import("layouts/LoginLayout.vue"),
    children: [
      { path: "", component: () => import("pages/ForgotPassword.vue") },
    ],
  },

  {
    path: "/signup",
    component: () => import("layouts/LoginLayout.vue"),
    children: [
      { path: "", component: () => import("pages/SignupPage.vue") },
      {
        path: "create-user",
        component: () => import("pages/MerchantCreateUser.vue"),
      },
      {
        path: "chooseplan",
        component: () => import("pages/ChoosePlan.vue"),
      },
      {
        path: "choose-payment",
        component: () => import("pages/ChoosePayment.vue"),
      },
      {
        path: "thankyou",
        component: () => import("pages/ThankYou.vue"),
      },
      {
        path: "payment-processing",
        component: () => import("pages/PaymentProcessing.vue"),
      },
      {
        path: "getbacktoyou",
        component: () => import("pages/GetBacktoyou.vue"),
      },
    ],
  },

  {
    path: "/dashboard",
    component: () => import("layouts/MainLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/DashboardPage.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/orders",
    component: () => import("layouts/MainLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/OrdersList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.orders",
        },
      },
    ],
  },

  {
    path: "/orderview",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "",
        name: "order-details",
        component: () => import("src/pages/OrderDetails.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "orders.view",
        },
      },
    ],
  },

  {
    path: "/menu",
    component: () => import("layouts/NoTopLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/MenuPage.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  //food manage start here
  {
    path: "/manage",
    component: () => import("layouts/FoodLayout.vue"),
    children: [
      {
        path: "items",
        component: () => import("src/pages/Manage/FoodItems.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "category",
        component: () => import("src/pages/Manage/CategoryList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "addoncategory",
        component: () => import("src/pages/Manage/AddonCategory.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "addonitems",
        component: () => import("src/pages/Manage/AddonItems.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "size",
        component: () => import("src/pages/Manage/SizeList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "ingredients",
        component: () => import("src/pages/Manage/IngredientsList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "cookingref",
        component: () => import("src/pages/Manage/CookingrefList.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/wallet",
    component: () => import("layouts/NoTopLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/WalletPage.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/restaurant",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "information",
        component: () => import("src/pages/MerchantInformation.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "address",
        component: () => import("src/pages/MerchantAddress.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "settings",
        component: () => import("src/pages/MerchantSettings.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "store-hours",
        component: () => import("src/pages/MerchantStoreHours.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "add-hours",
        component: () => import("src/pages/MerchantAddHours.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.store_hours_create",
        },
      },
      {
        path: "update-hours",
        component: () => import("src/pages/MerchantAddHours.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.store_hours_update",
        },
      },
    ],
  },

  {
    path: "/category",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "edit",
        component: () => import("src/pages/ManageCategory.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.category_update",
        },
      },
      {
        path: "add",
        component: () => import("src/pages/ManageCategory.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.category_create",
        },
      },
      {
        path: "sort",
        component: () => import("src/pages/ManageCategorySort.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.category_sort",
        },
      },
    ],
  },

  {
    path: "/item",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "add",
        component: () => import("src/pages/ManageItems.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.item_create",
        },
      },
      {
        path: "edit",
        component: () => import("src/pages/ManageItems.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.item_update",
        },
      },
      {
        path: "pricelist",
        component: () => import("src/pages/ItemPriceList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.item_price",
        },
      },
      {
        path: "addprice",
        component: () => import("src/pages/ItemAddPrice.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.itemprice_create",
        },
      },
      {
        path: "editprice",
        component: () => import("src/pages/ItemAddPrice.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.itemprice_update",
        },
      },
      {
        path: "attributes",
        component: () => import("src/pages/ItemAttributes.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.item_attributes",
        },
      },
      {
        path: "addonlist",
        component: () => import("src/pages/ItemAddonlist.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.item_addon",
        },
      },
      {
        path: "addonitem_create",
        component: () => import("src/pages/ItemAddonAdd.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.itemaddon_create",
        },
      },
      {
        path: "addonitem_update",
        component: () => import("src/pages/ItemAddonAdd.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.itemaddon_update",
        },
      },
      {
        path: "availability",
        component: () => import("src/pages/ItemAvailability.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.item_availability",
        },
      },
      {
        path: "inventory",
        component: () => import("src/pages/ItemInventory.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.item_inventory",
        },
      },
      {
        path: "promotionlist",
        component: () => import("src/pages/ItemPromotion.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.item_promos",
        },
      },
      {
        path: "promotioncreate",
        component: () => import("src/pages/ItemPromotionCreate.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.itempromo_create",
        },
      },
      {
        path: "promotionupdate",
        component: () => import("src/pages/ItemPromotionCreate.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.itempromo_update",
        },
      },
      {
        path: "gallery",
        component: () => import("src/pages/ItemGallery.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.item_gallery",
        },
      },
      {
        path: "create-gallery",
        component: () => import("src/pages/CreateItemGallery.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.item_gallery",
        },
      },
      {
        path: "seo",
        component: () => import("src/pages/ItemSeo.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.item_seo",
        },
      },
      {
        path: "sort",
        component: () => import("src/pages/SortItems.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.item_sort",
        },
      },
      {
        path: "addonitem_sort",
        component: () => import("src/pages/AddonItemSort.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/addcategory",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "add",
        component: () => import("src/pages/ManageAddonCategory.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.addoncategory_create",
        },
      },
      {
        path: "edit",
        component: () => import("src/pages/ManageAddonCategory.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.addoncategory_update",
        },
      },
      {
        path: "sort",
        component: () => import("src/pages/AddonCategorySort.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.addoncategory_sort",
        },
      },
    ],
  },

  {
    path: "/addonitems",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "add",
        component: () => import("src/pages/ManageAddonItems.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.addonitem_create",
        },
      },
      {
        path: "edit",
        component: () => import("src/pages/ManageAddonItems.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.addonitem_update",
        },
      },
      {
        path: "sort",
        component: () => import("src/pages/SortAddonItems.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "food.addonitem_sort",
        },
      },
    ],
  },

  {
    path: "/account-menu",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/AccountMenu.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/account",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "edit-profile",
        component: () => import("src/pages/EditProfile.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "change-password",
        component: () => import("src/pages/ChangePassword.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "language",
        component: () => import("src/pages/LanguageList.vue"),
        //meta: { requiresAuth: false },
      },
      {
        path: "delete",
        component: () => import("src/pages/DeleteAccount.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "deletety",
        component: () => import("src/pages/DeleteTy.vue"),
        meta: { requiresAuth: false },
      },
      {
        path: "legal",
        component: () => import("src/pages/LegalMenu.vue"),
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
    path: "/notifications",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/NotificationsList.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/search",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/SearchPage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "food",
        component: () => import("src/pages/SearchFood.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/customer",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/Customer/CustomerList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "review-list",
        component: () => import("src/pages/ReviewList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "details",
        component: () => import("src/pages/Customer/CustomerDetails.vue"),
        meta: { requiresAuth: true },
      },
      // {
      //   path: "order-history",
      //   component: () => import("src/pages/Customer/OrderHistory.vue"),
      //   meta: { requiresAuth: true },
      // },
    ],
  },

  {
    path: "/size",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "add",
        component: () => import("src/pages/ManageSize.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "attrmerchant.size_create",
        },
      },
      {
        path: "edit",
        component: () => import("src/pages/ManageSize.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "attrmerchant.size_update",
        },
      },
    ],
  },

  {
    path: "/ingredients",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "add",
        component: () => import("src/pages/ManageIngredients.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "attrmerchant.ingredients_create",
        },
      },
      {
        path: "edit",
        component: () => import("src/pages/ManageIngredients.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "attrmerchant.ingredients_update",
        },
      },
    ],
  },

  {
    path: "/cooking",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "add",
        component: () => import("src/pages/ManageCookingref.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "attrmerchant.cookingref_create",
        },
      },
      {
        path: "edit",
        component: () => import("src/pages/ManageCookingref.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "attrmerchant.cookingref_update",
        },
      },
    ],
  },

  {
    path: "/errornetwork",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/NetworkError.vue"),
      },
    ],
  },

  {
    path: "/update-app",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/UpdateApp.vue"),
      },
    ],
  },

  {
    path: "/settings",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "printers",
        component: () => import("src/pages/PrinterList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "printer-view",
        component: () => import("src/pages/PrinterManage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "add-printer",
        component: () => import("src/pages/PrinterManage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "location-enabled",
        component: () => import("src/pages/LocationEnabled.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/driver",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "assign",
        component: () => import("src/pages/Driver/AssignList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "add",
        component: () => import("src/pages/Driver/AddDriver.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.add",
        },
      },
      {
        path: "update",
        component: () => import("src/pages/Driver/AddDriver.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.update",
        },
      },
      {
        path: "overview",
        component: () => import("src/pages/Driver/OverviewInfo.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.overview",
        },
      },
      {
        path: "license",
        component: () => import("src/pages/Driver/AddLicense.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.license",
        },
      },
      {
        path: "vehicle",
        component: () => import("src/pages/Driver/AddVehicle.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.vehicle",
        },
      },
      {
        path: "bank-information",
        component: () => import("src/pages/Driver/BankInformation.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.bank_info",
        },
      },
      {
        path: "wallet",
        component: () => import("src/pages/Driver/WalletTransactions.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.wallet",
        },
      },
      {
        path: "cashout_transactions",
        component: () => import("src/pages/Driver/CashoutTransactions.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.cashout_transactions",
        },
      },
      {
        path: "delivery_transactions",
        component: () => import("src/pages/Driver/DeliveryTransactions.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.delivery_transactions",
        },
      },
      {
        path: "order_tips",
        component: () => import("src/pages/Driver/OrderTipsTransactions.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.order_tips",
        },
      },
      {
        path: "time_logs",
        component: () => import("src/pages/Driver/TimeLogs.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.time_logs",
        },
      },
      {
        path: "reviews",
        component: () => import("src/pages/Driver/ReviewsList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.review_ratings",
        },
      },
      {
        path: "create-car",
        component: () => import("src/pages/Driver/CarManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.addcar",
        },
      },
      {
        path: "update-car",
        component: () => import("src/pages/Driver/CarManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.update_car",
        },
      },
      {
        path: "create-group",
        component: () => import("src/pages/Driver/GroupManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.addgroup",
        },
      },
      {
        path: "update-group",
        component: () => import("src/pages/Driver/GroupManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.group_update",
        },
      },
      {
        path: "create-zone",
        component: () => import("src/pages/Driver/ZoneManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.zone_create",
        },
      },
      {
        path: "update-zone",
        component: () => import("src/pages/Driver/ZoneManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.zone_update",
        },
      },
      {
        path: "create-schedule",
        component: () => import("src/pages/Driver/ScheduleManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.schedule_add",
        },
      },
      {
        path: "update-schedule",
        component: () => import("src/pages/Driver/ScheduleManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.schedule_update",
        },
      },
      {
        path: "create-shifts",
        component: () => import("src/pages/Driver/ShiftManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.shift_add",
        },
      },
      {
        path: "update-shifts",
        component: () => import("src/pages/Driver/ShiftManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.shift_update",
        },
      },
      {
        path: "update-review",
        component: () => import("src/pages/Driver/ReviewManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.review_update",
        },
      },
      {
        path: "collect-cash-create",
        component: () => import("src/pages/Delivery/CollectcashManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.collect_cash_add",
        },
      },
    ],
  },

  {
    path: "/table",
    component: () => import("layouts/MainLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/Table/TableMenu.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.list",
        },
      },
      {
        path: "settings",
        component: () => import("src/pages/Table/SettingsPage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.settings",
        },
      },

      {
        path: "shifts",
        component: () => import("src/pages/Table/ShiftList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.shifts",
        },
      },
      {
        path: "rooms",
        component: () => import("src/pages/Table/RoomList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.room",
        },
      },
      {
        path: "tables",
        component: () => import("src/pages/Table/TableList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.tables",
        },
      },
    ],
  },

  {
    path: "/tables",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "reservation_overview",
        component: () => import("src/pages/Table/ReservationOverview.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.reservation_overview",
        },
      },
      {
        path: "update_reservation",
        component: () => import("src/pages/Table/TableForms.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.update_reservation",
        },
      },
      {
        path: "create_reservation",
        component: () => import("src/pages/Table/TableForms.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.create_reservation",
        },
      },
      {
        path: "create_shift",
        component: () => import("src/pages/Table/CreateShift.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.create_shift",
        },
      },
      {
        path: "udapte_shift",
        component: () => import("src/pages/Table/CreateShift.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.update_shift",
        },
      },
      {
        path: "rooms_create",
        component: () => import("src/pages/Table/RoomCreate.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.create_room",
        },
      },
      {
        path: "rooms_update",
        component: () => import("src/pages/Table/RoomCreate.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.update_room",
        },
      },
      {
        path: "table_create",
        component: () => import("src/pages/Table/TableCreate.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.create_table",
        },
      },
      {
        path: "table_update",
        component: () => import("src/pages/Table/TableCreate.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "booking.update_tables",
        },
      },
      {
        path: "search",
        component: () => import("src/pages/Table/SearchBooking.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "search-shift",
        component: () => import("src/pages/Table/SearchShift.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "search-rooms",
        component: () => import("src/pages/Table/SearchRooms.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "search-tables",
        component: () => import("src/pages/Table/SearchTables.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/pos",
    //component: () => import("layouts/LayoutPos.vue"),
    component: () => import("layouts/MainLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/POS/CreateOrder.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "pos.create_order",
        },
      },
      {
        path: "information",
        component: () => import("src/pages/POS/OrderInformation.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "on-hold",
        component: () => import("src/pages/POS/OnHoldorders.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "pos.create_order",
        },
      },
      {
        path: "list",
        component: () => import("src/pages/POS/OrderList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "pos.orders",
        },
      },
    ],
  },

  {
    path: "/pos-order",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "information",
        component: () => import("src/pages/POS/OrderInformation.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "add-address",
        component: () => import("src/pages/POS/AddAddress.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "search-on-hold",
        component: () => import("src/pages/POS/SearchHoldorders.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "search-item",
        component: () => import("src/pages/POS/SearchFoodItems.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/delivery-management",
    component: () => import("layouts/LayoutDelivery.vue"),
    children: [
      {
        path: "cashout",
        component: () => import("src/pages/Delivery/CashOutlist.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.cashout_list",
        },
      },
      {
        path: "collect-cash",
        component: () => import("src/pages/Delivery/CollectCash.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.collect_cash",
        },
      },
      {
        path: "driver",
        component: () => import("src/pages/Delivery/DriverList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.list",
        },
      },
      {
        path: "car",
        component: () => import("src/pages/Delivery/CarList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.carlist",
        },
      },
      {
        path: "groups",
        component: () => import("src/pages/Delivery/GroupList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.group_list",
        },
      },
      {
        path: "zones",
        component: () => import("src/pages/Delivery/ZoneList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.zone_list",
        },
      },
      {
        path: "schedule",
        component: () => import("src/pages/Delivery/ScheduleList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.schedule_list",
        },
      },
      {
        path: "shifts",
        component: () => import("src/pages/Delivery/ShiftList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.shift_list",
        },
      },
      {
        path: "reviews",
        component: () => import("src/pages/Delivery/ReviewList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantdriver.review_list",
        },
      },
    ],
  },

  {
    path: "/services",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "delivery_settings",
        component: () => import("src/pages/Services/DeliverySettings.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "services.delivery_settings",
        },
      },
      {
        path: "charges_table",
        component: () => import("src/pages/Services/DynamicRates.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "services.charges_table",
        },
      },
      {
        path: "settings_pickup",
        component: () => import("src/pages/Services/PickupSettings.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "services.settings_pickup",
        },
      },
      {
        path: "settings_dinein",
        component: () => import("src/pages/Services/DineinSettings.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "services.settings_dinein",
        },
      },
    ],
  },

  {
    path: "/rates",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "create-rate",
        component: () => import("src/pages/Services/RatesManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "services.chargestable_create",
        },
      },
      {
        path: "update-rate",
        component: () => import("src/pages/Services/RatesManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "services.chargestable_update",
        },
      },
    ],
  },

  {
    path: "/promo",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "coupon-list",
        component: () => import("src/pages/Promo/CouponList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.coupon",
        },
      },
      {
        path: "create-coupon",
        component: () => import("src/pages/Promo/CouponManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.coupon_create",
        },
      },
      {
        path: "update-coupon",
        component: () => import("src/pages/Promo/CouponManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.coupon_update",
        },
      },
      {
        path: "offers-list",
        component: () => import("src/pages/Promo/OffersList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "create-offers",
        component: () => import("src/pages/Promo/OffersManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.offer_create",
        },
      },
      {
        path: "update-offers",
        component: () => import("src/pages/Promo/OffersManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.offer_update",
        },
      },
    ],
  },

  {
    path: "/promos",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "create-coupon",
        component: () => import("src/pages/Promo/CouponManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.coupon_create",
        },
      },
      {
        path: "update-coupon",
        component: () => import("src/pages/Promo/CouponManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.coupon_update",
        },
      },
      {
        path: "create-offers",
        component: () => import("src/pages/Promo/OffersManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.offer_create",
        },
      },
      {
        path: "update-offers",
        component: () => import("src/pages/Promo/OffersManage.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.offer_update",
        },
      },
    ],
  },

  {
    path: "/images",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "gallery",
        component: () => import("src/pages/Images/GalleryList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "images.gallery",
        },
      },
      {
        path: "create-gallery",
        component: () => import("src/pages/Images/GalleryManages.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "update-gallery",
        component: () => import("src/pages/Images/GalleryManages.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "media_library",
        component: () => import("src/pages/Images/MediaList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "images.media_library",
        },
      },
      {
        path: "create-media",
        component: () => import("src/pages/Images/MediaManage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "update-media",
        component: () => import("src/pages/Images/MediaManage.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/image",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "create-gallery",
        component: () => import("src/pages/Images/GalleryManages.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "update-gallery",
        component: () => import("src/pages/Images/GalleryManages.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "create-media",
        component: () => import("src/pages/Images/MediaManage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "update-media",
        component: () => import("src/pages/Images/MediaManage.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/account",
    component: () => import("layouts/LayoutAccount.vue"),
    children: [
      {
        path: "statement",
        component: () => import("src/pages/Account/StatementTransaction.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "commission.statement",
        },
      },
      {
        path: "withdrawals",
        component: () => import("src/pages/Account/WithdrawalTransaction.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "commission.withdrawals",
        },
      },
    ],
  },

  {
    path: "/merchant",
    // component: () => import("layouts/LayoutMerchant.vue"),
    //component: () => import("layouts/MainLayout.vue"),
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/Merchant/MerchantInfo.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.edit",
        },
      },
      {
        path: "login",
        component: () => import("src/pages/Merchant/MerchantLogin.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.login",
        },
      },
      {
        path: "address",
        component: () => import("src/pages/Merchant/MerchantAddress.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.address",
        },
      },
      {
        path: "settings",
        component: () => import("src/pages/Merchant/MerchantSettings.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.settings",
        },
      },
      {
        path: "store-hours",
        component: () => import("src/pages/Merchant/MerchantOpenings.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.store_hours",
        },
      },
      {
        path: "timezone",
        component: () => import("src/pages/Merchant/TimeZone.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.timezone",
        },
      },
      {
        path: "zone",
        component: () => import("src/pages/Merchant/MerchantZone.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchant.zone_settings",
        },
      },
    ],
  },

  {
    path: "/invoice",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "list",
        component: () => import("src/pages/Invoice/InvoiceList.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "invoicemerchant.list",
        },
      },
      {
        path: "upload",
        component: () => import("src/pages/Invoice/InvoiceUpload.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "invoicemerchant.uploaddeposit",
        },
      },
    ],
  },

  {
    path: "/inv",
    component: () => import("layouts/LayoutInvoice.vue"),
    children: [
      {
        path: "view",
        component: () => import("src/pages/Invoice/InvoiceDetails.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "invoicemerchant.view",
        },
      },
      {
        path: "payment",
        component: () => import("src/pages/Invoice/InvoicePayment.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "activity",
        component: () => import("src/pages/Invoice/InvoiceActivity.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/reports",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "dailysalesreport",
        component: () => import("src/pages/Reports/DailySalesreport.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantreport.dailysalesreport",
        },
      },
      {
        path: "sales",
        component: () => import("src/pages/Reports/SalesReport.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantreport.sales",
        },
      },
      {
        path: "summary",
        component: () => import("src/pages/Reports/ItemSummary.vue"),
        meta: {
          requiresAuth: true,
          checkPermission: true,
          permissionName: "merchantreport.summary",
        },
      },
    ],
  },

  {
    path: "/payment",
    //component: () => import("layouts/LayoutPayment.vue"),
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "payment_list",
        component: () => import("src/pages/Payment/PaymentList.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "bank_deposit",
        component: () => import("src/pages/Payment/BankDepositList.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/payments",
    component: () => import("layouts/NotopfooterLayout.vue"),
    children: [
      {
        path: "create-payment",
        component: () => import("src/pages/Payment/PaymentManage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "update-payment",
        component: () => import("src/pages/Payment/PaymentManage.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "update-bank-deposit",
        component: () => import("src/pages/Payment/ManageBankDeposit.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/chat",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/Chat/ChatMain.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "conversation",
        name: "conversation",
        component: () => import("src/pages/Chat/ChatConversation.vue"),
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/campaigns",
    component: () => import("layouts/MainLayoutPage.vue"),
    children: [
      {
        path: "",
        component: () => import("src/pages/campaigns/PointSettings.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "points_settings",
        component: () => import("src/pages/campaigns/PointSettings.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "suggested_items",
        component: () => import("src/pages/campaigns/SuggestedItems.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "add_suggested_items",
        component: () => import("src/pages/campaigns/AddSuggestedItems.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "free_item",
        component: () => import("src/pages/campaigns/SpentFreeItems.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "add_free_items",
        component: () => import("src/pages/campaigns/AddSpentFreeItems.vue"),
        meta: { requiresAuth: true },
      },
      {
        path: "update_free_items",
        component: () => import("src/pages/campaigns/AddSpentFreeItems.vue"),
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
