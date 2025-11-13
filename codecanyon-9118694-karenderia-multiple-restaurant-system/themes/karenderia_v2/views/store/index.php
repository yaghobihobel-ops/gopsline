
<div id="vm_home_search">

  <div class="d-block d-lg-none">
    <div class="mobile-home-banner"></div>
  </div>

  <div class="container-fluid d-flex justify-content-center" id="main-search-banner">
      <div class="banner-center align-self-center">
         <h2 class="text-center mb-3"><?php echo t("Let's find best food for you")?></h2>
          <div class="home-search-wrap" >     
            
           <component-auto-complete
            ref="auto_complete"
            :label="{
                enter_address : '<?php echo CJavaScript::quote(t("Enter your street and house number"))?>', 
            }"
            formatted_address=""
            @after-choose="afterChoose"
            @after-getcurrentlocation="afterGetcurrentlocation"
            @after-pointaddress="afterPointaddress"
            :enabled_locate="<?php echo true;?>"
            >
            </component-auto-complete>

          </div>
          <!-- home-search-wrap -->
      </div>
      <!-- banner-center -->
  </div>
  <!-- main-search-banner -->

  <?php $maps_config = CMaps::config();?>        
      <components-select-address
      ref="address_modal"
      :data="deliveryAddress"
      keys="<?php echo $maps_config['key']?>"
      provider="<?php echo $maps_config['provider']?>"
      zoom="<?php echo $maps_config['zoom']?>"
      :center="{
        lat: '<?php echo CJavaScript::quote($maps_config['default_lat'])?>',  
        lng: '<?php echo CJavaScript::quote($maps_config['default_lng'])?>',  
      }"        
      :label="{
          exact_location : '<?php echo CJavaScript::quote(t("What's your exact location?"))?>', 
          enter_address : '<?php echo CJavaScript::quote(t("Enter your street and house number"))?>', 
          submit : '<?php echo CJavaScript::quote(t("Submit"))?>', 
      }"
      @after-changeaddress="afterPointaddress"
      >
    </components-select-address>      
    
    <components-address-form
    ref="address_form"
    :location_data="location_data"
    @on-savelocation="onSavelocation"
    >	
    </components-address-form>

</div>
<!-- vm_home_search -->

<script type="text/x-template" id="xtemplate_address_form">
<?php $this->renderPartial("//account/checkout-address")?>
</script>


<DIV id="vue-home-widgets" >

<div class="container mt-4 mb-3" v-cloak >
    
  <!-- CUISINE LIST -->
  <components-cuisine-list
      @after-getcuisine="afterGetcuisine"
      title="<?php echo t("Your favorite cuisines")?>"
      >
  </components-cuisine-list>   
  <!-- CUISINE LIST -->
      
  <components-swiper-list
    ref="ref_swiperlist"
    query="popular"         
    title="<?php echo t("Popular Restaurants Near You")?>"    
  >
  </components-swiper-list>    
  
  <components-featured-list
    ref="ref_featured_list"    
    title="<?php echo t("Featured Items")?>"   
    @view-item="viewItem"
  >
  </components-featured-list>    
  
  <components-item-dialog
  ref="ref_item_dialog"  
  @after-addtocart="afterAddtocart"  
  :label="<?php echo CommonUtility::safeJsonEncode([
    'new_order'=>t("New order"),
    'your_order'=>t("Your order contains items from {restaurant_name}. Create a new order to add items."),
    'yes'=>t("Yes"),
    'cancel'=>t("Cancel"),
  ])?>"
  >
  </components-item-dialog>

  <components-swiper-list
    ref="ref_swiperlist"
    query="new"         
    title="<?php echo t("New Restaurants")?>"    
  >
  </components-swiper-list>      
   
  <components-join></components-join>     
              
</div> <!--container-->

<?php if(isset(Yii::app()->params['settings']['enabled_mobileapp_section'])):?>
<?php if(Yii::app()->params['settings']['enabled_mobileapp_section']==1):?>
<div class="section-mobileapp section-newmobileapp tree-columns-center d-none d-md-block"> 
<div class="container">
   <div class="mb-0 row">
   
   <div class="col-lg-4 col-md-4 mb-4 mb-lg-3">
      <div class="d-flex align-items-center">
       <div class="w-100 text-center text-md-left">
         <h5><?php echo t("Best restaurants")?></h5>
         <h1 class="mb-4"><?php echo t("In your pocket")?></h1>
         <p class=""><?php echo t("Order from your favorite restaurants & track on the go, with the all-new K app.")?></p>
       </div>
      </div>
   </div>  
   
   <div class="col-lg-4 col-md-4 mb-4 mb-lg-3">
      <div class="d-flex align-items-center">
       <div class="w-100 text-center">
          <img class="mobileapp" src="<?php echo Yii::app()->theme->baseUrl."/assets/images/mobileapp.png"?>" />
       </div>
      </div>
   </div>
   
    <div class="col-lg-4 col-md-4 mb-4 mb-lg-3">
      <div class="d-flex align-items-center">
       <div class="w-100 text-center text-md-right">
         <h5><?php echo t("Download")?></h5>
         <h1 class="mb-4"><?php echo t("K mobile app")?></h1>
         
         <div class="app-store-wrap">
           <a href="<?php echo  !empty($ios_download_url)?$ios_download_url:'#' ?>" class="d-inline mr-2" 
           <?php echo !empty($ios_download_url)?'target="_blank"':""; ?>
           >
		        <img src="<?php echo Yii::app()->theme->baseUrl?>/assets/images/app-store@2x.png">
		       </a>
          <a href="<?php echo !empty($android_download_url)?$android_download_url:'#' ?>" class="d-inline" 
          <?php echo !empty($android_download_url)?'target="_blank"':""; ?>
          >
            <img src="<?php echo Yii::app()->theme->baseUrl?>/assets/images/google-play@2x.png">
          </a>
         </div>
         
       </div>
      </div>
   </div>
   
   </div> <!--row-->
</div> <!--container-->
</div> <!--sections-->

<!-- section mobile app view -->
<div class="d-block d-md-none">
  <div class="section-mobileapp section-newmobileapp"> 
     <div class="container text-center"> 
     
         <h5><?php echo t("Best restaurants")?></h5>
         <h1 class="mb-3"><?php echo t("In your pocket")?></h1>
         <p class=""><?php echo t("Order from your favorite restaurants & track on the go, with the all-new K app.")?></p>

         <div class="d-flex justify-content-center app-store-wrap mb-5 mt-4">
           <div class="mr-2">
           <a href="<?php echo  !empty($ios_download_url)?$ios_download_url:'#' ?>" class="d-inline mr-2" 
           <?php echo !empty($ios_download_url)?'target="_blank"':""; ?>
           >
              <img src="<?php echo Yii::app()->theme->baseUrl?>/assets/images/app-store@2x.png">
            </a>
           </div>
           <div class="">
           <a href="<?php echo !empty($android_download_url)?$android_download_url:'#' ?>" class="d-inline" 
          <?php echo !empty($android_download_url)?'target="_blank"':""; ?>
          >
              <img src="<?php echo Yii::app()->theme->baseUrl?>/assets/images/google-play@2x.png">
            </a>
           </div>
         </div>

         <img class="mobileapp" src="<?php echo Yii::app()->theme->baseUrl."/assets/images/mobileapp-half.png"?>" />

     </div>
   </div>
</div>
<!-- section mobile app view -->
<?php endif?>
<?php endif?>

<div class="container mb-4">
<components-swiper-list
    ref="ref_swiperlist"
    query="best_seller"         
    title="<?php echo t("Best Seller Restaurants")?>"    
  >
  </components-swiper-list>      
</div>

</DIV>
<!--vue-home-widgets-->

<?php
$this->renderPartial("//components/template_join",[
  'website_title'=>$website_title
]);
$this->renderPartial("//components/template_cuisine_list");
$this->renderPartial("//components/template_swiper_list");
$this->renderPartial("//components/template_featured_item_list");
$this->renderPartial("//components/item-details",array(
  'is_mobile'=>Yii::app()->params['isMobile']
));