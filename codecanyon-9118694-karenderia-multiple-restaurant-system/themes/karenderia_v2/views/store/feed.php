<div id="vue-feed" class="container-fluid"  >


<!-- search and filter mobile view -->
<div id="feed-search-mobile" class="d-block d-lg-none mt-2 mb-3">

  <div class="position-relative inputs-box-wrap">
     <input @click="showSearchSuggestion" class="inputs-box-grey rounded" placeholder="<?php echo t("Search")?>">
     <div class="search_placeholder pos-right img-15"></div>       
	 <div class="filter_wrap"><a @click="showFilter" class="filter_placeholder btn"></a></div>
  </div>

</div>
<!-- search and filter mobile view -->

<component-filter-feed
ref="filter_feed"
@after-filter="afterApplyFilter"
:data_attributes="data_attributes"
:data_cuisine="data_cuisine"
:label="{		    
	filters: '<?php echo CJavaScript::quote(t("Filters"))?>', 
	price_range: '<?php echo CJavaScript::quote(t("Price range"))?>', 		    
	cuisine: '<?php echo CJavaScript::quote(t("Cuisines"))?>', 
	max_delivery_fee: '<?php echo CJavaScript::quote(t("Max Delivery Fee"))?>', 
	delivery_fee: '<?php echo CJavaScript::quote(t("Delivery Fee"))?>', 
	ratings: '<?php echo CJavaScript::quote(t("Ratings"))?>', 
	over: '<?php echo CJavaScript::quote(t("Over"))?>', 
	done: '<?php echo CJavaScript::quote(t("Done"))?>', 
	clear_all: '<?php echo CJavaScript::quote(t("Clear all"))?>', 	
}"	    
>
</component-filter-feed>

<component-mobile-search-suggestion
ref="search_suggestion"
ajax_url="<?php echo Yii::app()->createUrl("/api")?>" 
:tabs_suggestion='<?php echo json_encode($tabs_suggestion)?>'
:label="{		    
	clear: '<?php echo CJavaScript::quote(t("Clear"))?>', 
	search: '<?php echo CJavaScript::quote(t("Search"))?>', 		    
	no_results: '<?php echo CJavaScript::quote(t("No results"))?>',	
}"	    
>
</component-mobile-search-suggestion>


<div class="row mt-2 mt-lg-4 row mb-4">
  
 <div class="col-lg-3 col-md-3 d-none d-lg-block column-1">
 
   <el-skeleton :loading="data_attributes_loading" animated :count="4">
   <template #template>
       <div class="mb-2"><el-skeleton :rows="5" /></div>
   </template>
   <template #default>   

   <div class="d-flex justify-content-between align-items-center mb-2" >
     <div class="flex-col"><h4 class="m-0" v-cloak >{{this.total_message}}</h4></div>
     <div class="flex-col" v-if="hasFilter"  v-cloak  >
       <a href="javascript:;" @click="clearFilter" ><p class="m-0" ><u><?php echo t("Clear all")?></u></p></a>
     </div>
   </div>
 
   <div class="accordion section-filter" id="sectionFilter">
   
    <!--SORT-->    
    <div class="filter-row border-bottom pb-2 pt-2">
     <h5>
     <a href="#filterSort" class="d-block" data-toggle="collapse" aria-expanded="true" aria-controls="filterSort"  >
     <?php echo t("Filter")?>
     </a>
     </h5>   
   
     <div id="filterSort" class="collapse show" aria-labelledby="headingOne" v-cloak >   
     
      <div v-for="(sort_by, key) in data_attributes.sort_by" class="row m-0 ml-2 mb-2">
		<div class="custom-control custom-radio">
	      <input @click="AutoFeed"  v-model="sortby" :value="key" type="radio" :id="key" name="sort" class="custom-control-input">
	      <label class="custom-control-label" :for="key">{{sort_by}}</label>
		 </div>   		      
	  </div><!--row-->  
      
     </div> <!--filterSort-->   
   </div> <!--filter-row-->
   <!--END SORT-->
   
   
     <!--PRICE-->
   <div class="filter-row border-bottom pb-2 pt-2">
     <h5>
     <a href="#filterPrice" class="d-block collapsed" data-toggle="collapse" aria-expanded="false" aria-controls="filterPrice"  >
     <?php echo t("Price range")?>
     </a>
   </h5>   
   
    <div id="filterPrice" class="collapse" :class="{show:collapse}" aria-labelledby="headingOne" >
        
       <div class="btn-group btn-group-toggle input-group-small mt-2 mb-2" >
          <label  v-for="(price, key) in data_attributes.price_range" class="btn" :class="{ active: price_range==key }"   >
             <input @click="AutoFeed"  type="radio" :value="key" name="price_range" v-model="price_range"> 
             <!-- {{price}} -->
			 <span v-html="price"></span>
           </label>                                               
       </div>
   
     </div> <!-- filterCuisine-->  
   </div> <!--filter-row-->
   
   <!--END PRICE-->
   
   
   <!--CUISINE-->
   
     <div class="filter-row border-bottom pb-2 pt-2">
     <h5>
     <a href="#filterCuisine" class="d-block collapsed" data-toggle="collapse" aria-expanded="false" aria-controls="filterCuisine"  >
     <?php echo t("Cuisines")?>
     </a>
     </h5>   
   
     <div id="filterCuisine" class="collapse" :class="{show:collapse}" aria-labelledby="headingOne" >
            
        <div class="row m-0">              
            <template v-for="(item_cuisine, index) in data_cuisine" >         
	        <div class="col-lg-6 col-md-6 mb-4 mb-lg-3" v-if="index<=5">
	         <div class="custom-control custom-checkbox">	          
	          <input @click="AutoFeed" type="checkbox" class="custom-control-input cuisine" :id="'cuisine'+item_cuisine.cuisine_id" 
              :value="item_cuisine.cuisine_id"
              v-model="cuisine"
	           >
	          <label class="custom-control-label" :for="'cuisine'+item_cuisine.cuisine_id">
	          {{item_cuisine.cuisine_name}}
	          </label>
	         </div>   		      
	        </div> <!--col-->	         	       
	        </template>	       	      	       
	    </div><!-- row-->
	    	   
	    <div class="collapse" id="moreCuisine">
	      <div class="row m-0">
	       
	         <template v-if="data_cuisine[6]">
	         <template v-for="(item_cuisine, index) in data_cuisine.slice(6)" >
	         <div class="col-lg-6 col-md-6 mb-4 mb-lg-3"> 	         
	         <div class="custom-control custom-checkbox">	          
	          <input @click="AutoFeed"  v-model="cuisine" type="checkbox" class="custom-control-input cuisine" :id="'cuisine'+item_cuisine.cuisine_id"
	          :value="item_cuisine.cuisine_id" >
	          <label class="custom-control-label" :for="'cuisine'+item_cuisine.cuisine_id" >
	           {{item_cuisine.cuisine_name}}
	          </label>
	         </div>   		   	         
	         </div> <!--col-->
	         </template>
	         </template>
	         
	      </div> <!--row-->
	    </div> <!--collapse-->
	    
	    <template v-if="data_cuisine[6]">
	    <div class="row ml-3 mt-1 mt-0 mb-2">
		 <a class="btn link more-cuisine" data-toggle="collapse" href="#moreCuisine" role="button" aria-expanded="false" aria-controls="collapseExample">
		  <u><?php echo t("Show more +")?></u>
		 </a>
		</div>
		</template>
		  	    
     
     </div> <!-- filterCuisine-->  
   </div> <!--filter-row-->

   <!--END CUISINE-->
   
   
   <!--MAX DELIVERY FEE-->
   <div class="filter-row border-bottom pb-2 pt-2">
     <h5>
     <a href="#filterMinimum" class="d-block collapsed" data-toggle="collapse" aria-expanded="false" aria-controls="filterMinimum"  >
     <?php echo t("Max Delivery Fee")?>
     </a>
     </h5>   
   
     <div id="filterMinimum" class="collapse" :class="{show:collapse}" aria-labelledby="headingOne" >       
     
     <div class="form-group">
	    <label for="formControlRange"><?php echo t("Delivery Fee")?> <b><span class="min-selected-range"></span></b></label>
	    <input v-model="max_delivery_fee" 
	          id="min_range_slider" value="10" type="range" class="custom-range" id="formControlRange"  min="1" max="20" >
	  </div>
     
     </div> <!-- filterMinimum-->  
   </div> <!--filter-row-->
   <!--END MAX DELIVERY FEE-->
   
   
   <!--RATINGS-->
    <div class="filter-row border-bottom pb-2 pt-2">
     <h5>
     <a href="#filterRating" class="d-block collapsed" data-toggle="collapse" aria-expanded="false" aria-controls="filterRating"  >
     <?php echo t("Ratings")?>
     </a>
     </h5>   
   
     <div id="filterRating" class="collapse" :class="{show:collapse}" aria-labelledby="headingOne" >    
       
         <p class="bold"><?php echo t("Over")?> {{rating}}</p>
         <star-rating  
         v-model:rating="rating"
		 :star-size="30"
		 :show-rating="false" 
		 @update:rating="rating = $event"
		 >
		 </star-rating>

     </div>
     <!--filterRating-->
     
     
   </div> <!--filter-row-->
   <!--END RATINGS-->
   
   
   </div> <!--section-filter-->
  
   <div class="mt-3 mb-3">
   
   <!--SUBMIT BUTTON-->
   
   <!--<button @click="Search(false)" type="submit" class="btn btn-green w-100" 
   :class="{ loading: is_loading }" 
   :disabled="!hasFilter"
   >
     <span class="label"><?php echo t("Show restaurants")?></span>
     <div class="m-auto circle-loader" data-loader="circle-side"></div>
   </button>-->
   </div>
   
   </template>
   </el-skeleton>

  </div> <!--column-1-->
  <!--FILTERS-->

  
 <!--SEARCH RESULTS-->  
 <div class="col-lg-9 col-md-12 column-2">
 
 <div class="d-block d-lg-none"><h4 class="m-0" v-cloak >{{total_message}}</h4></div>

 <div class="mb-4">	
    <components-banner
	ref="ref_banner"
	@after-getbanner="afterGetbanner"
	>
    </components-banner>  
 </div>
 
 <template v-if="!hasData && !is_loading">
	<div v-if="hasFilter">
		<h3><?php echo t("0 Result(s)")?></h3>
		<p class="m-0 text-muted"><?php echo t("No available restaurant with your selected filters")?>.</p>
	</div>
	<div v-else>
	  <h3><?php echo t("Sorry! We're not there yet")?></h3>
      <p><?php echo t("We're working hard to expand our area. However, we're not in this location yet. So sorry about this, we'd still love to have you as a customer.")?></p>
	</div>
 </template>
 
 
    <el-skeleton :loading="is_loading" animated :count="4" >
	<template #template>
	   <div class="row equal align-items-center">	  
			<div v-for="dummy_index in 3" class="col-lg-4  col-md-6 mb-3 list-items">
				<div><el-skeleton-item variant="image" style="width: 100%; height: 170px" /></div>
				<div><el-skeleton-item style="width: 50%;" variant="text" /></div>
				<div><el-skeleton-item  variant="text" /></div>
			</div>
       </div>
	</template>  
	<template #default>	

	<!-- <pre>{{datas}}</pre> -->
		
	<div class="row no-gutters">
	  <template v-for="items in datas">
	    <div class="col-lg-3 col-md-3 col-sm-6 p-1 mb-3 ">		  
		   <a :href="items.merchant_url" class="rounded-box no-hover d-block" type="button" 
       :class="{ 'make-grey': items.merchant_open_status=='0' || items.close_store=='1' || items.disabled_ordering=='1' || items.holiday_status=='1' }" 
        >
		      <div class="position-relative"> 
				     <div class="with-promo" v-if="items.promos" ><?php echo t("Promo")?></div>
             <div class="fav-floating" v-if="!is_guest">
                <component-save-store
                :active="items.saved_store=='1'?true:false"
                :merchant_id="items.merchant_id"
                @after-save="afterSaveStore(items)"
                />
                </component-save-store>
             </div>

             <div v-if="items.merchant_open_status=='0'" class="layer-grey"></div>
             <div v-else-if="items.close_store == '1' || items.disabled_ordering == '1' || items.disabled_ordering=='1' || items.pause_ordering=='1' ||
             items.holiday_status=='1'  " 
              class="layer-black d-flex align-items-center justify-content-center" >
             </div>

             <div v-if="items.close_store == '1' || items.disabled_ordering=='1'" 
                class="layer-content d-flex align-items-center justify-content-center">
                <p class="bold"><?php echo t("Currently unavailable")?></p>
              </div>
              
              <div v-if="items.pause_ordering=='1' && items.disabled_ordering!='1' && items.close_store!='1' " 
                class="layer-content d-flex align-items-center justify-content-center">
                  <p class="bold" v-if="pause_reason_data[items.merchant_id]">{{pause_reason_data[items.merchant_id]}}</p>
                  <p class="bold" v-else><?php echo t("Currently unavailable")?></p>
              </div>

              <div v-if="items.holiday_status == '1'" 
                class="layer-content d-flex align-items-center justify-content-center">
                <p class="bold text-capitalize">{{ items.holiday_reason }}</p>
              </div>
              
             
			       <el-image :src="items.url_logo" lazy ></el-image>                
			    </div>
          <div class="p-2">			     

          <h6 v-if="items.merchant_open_status=='0'" class="m-0">
	          {{items.next_opening}}
	        </h6> 
          <h5 class="text-truncate">{{ items.restaurant_name }}</h5>
          
          <div class="font-weight-light truncate mb-1">{{ items.cuisines }}</div>
          <div class="d-flex justify-content-between">
            <div>
                <div class="d-flex">
                    <div class="mr-1"><i class="fas fa-star gold-color"></i></div>
                    <div>{{items.ratings.rating}}</div>
                </div>                        
            </div>
            <div>
                <div class="d-flex">
                    <div class="mr-1"><i class="zmdi zmdi-time"></i></div>
                    <div class="truncate">{{items.estimation}}</div>
                </div>                        
            </div>
            <div>
              <div class="d-flex">
                    <div class="mr-1">&bullet;</div>
                    <div class="truncate">{{items.distance_pretty}}</div>
                </div>                        
            </div>
          </div>

          <template v-if="items.promos">
            <template v-for="promo in items.promos">
            <div class="d-flex align-items-center">		
              <div class="with-promo-icon"></div>
              <div class="text-truncate">{{ promo.discount_name }}</div>
            </div>
            </template>
          </template>

          </div> 
          <!-- p-2 -->			  
       </a>		 
		   <!-- rounded-box -->		   
		</div>
	  </template>	
	</div>
	
	</template>
	</el-skeleton>
	
 
    
	<!--LOAD MORE-->	
	<div class="d-flex justify-content-center mt-2 mt-lg-5">
	  <template v-if="hasMore">
	  <a href="javascript:;" @click="ShowMore" class="btn btn-black m-auto w25"
	    :class="{ loading: is_loading }"       
	  >	     
	     <span class="label"><?php echo t("Show more")?></span>
         <div class="m-auto circle-loader" data-loader="circle-side"></div>
	  </a>
	  </template>
	  
	  <template v-else>
	  <template v-if="hasData">
	    <p class="text-muted" v-if="page>1"><?php echo t("end of result")?></p>
	  </template>
	  </template>
	  
	</div>	
	<!--END LOAD MORE-->
		


 
 </div><!--column-2-->
 <!--END SEARCH RESULTS-->
 
</div> <!--section-results-->


<div class="section-fast-delivery tree-columns-center d-none d-lg-block">
  <div class="row">
  
  <div class="col col-4">
      <div class="d-flex align-items-center">
       <div class="w-100">      
        <img class="rider mirror" src="<?php echo Yii::app()->theme->baseUrl."/assets/images/rider.png"?>" />
       </div>
      </div>
   </div>  
   
   <div class="col col-4">
      <div class="d-flex align-items-center">
       <div class="w-100 text-center">
       
         <h5><?php echo t("Fastest delivery in")?></h5>
		 <?php if(is_array($place_details) && count($place_details)>=1):?>
         <h1 class="mb-4"><?php echo $place_details['address']['formatted_address']?></h1>
		 <?php endif;?>
         <p><?php echo t("Receive food in less than 20 minutes")?></p>   
       
         <!-- <a href="" class="btn btn-black w25"><?php echo t("Check")?></a> -->
         
       </div>
      </div>
   </div>
   
   <div class="col col-4">
      <div class="d-flex align-items-center">
       <div class="w-100 text-right">      
       <img class="rider" src="<?php echo Yii::app()->theme->baseUrl."/assets/images/rider.png"?>" />
       </div>
      </div>
   </div>   
  
  </div> <!--row-->
</div> <!--section-fast-delivery-->

<!-- mobile view -->
<div class="d-block d-lg-none rounded mb-3 section-fast-delivery-mobile">

     <div class="w-100 text-center pt-3 pt-md-5">       
	   <h5><?php echo t("Fastest delivery in")?></h5>	   
	   <?php if(is_array($place_details) && count($place_details)>=1):?>
         <h1 class="mb-4"><?php echo $place_details['address']['formatted_address']?></h1>
	   <?php endif;?>
	   <p><?php echo t("Receive food in less than 20 minutes")?></p>   
	 
	   <a href="" class="btn btn-black w25"><?php echo t("Check")?></a>	   
	 </div>

</div>
<!-- mobile view -->

</template>

<!--NO RESULTS-->
<!-- <template v-else> -->

<!-- <div class="container mt-3 mb-5" v-if="!is_loading">

<div class="no-results-section mb-4 mt-5">
  <img class="img-350 m-auto d-block" src="<?php echo Yii::app()->theme->baseUrl."/assets/images/404@2x.png"?>" />
</div>

<div class="text-center w-50 m-auto">
  <h3><?php echo t("Sorry! We're not there yet")?></h3>
  <p><?php echo t("We're working hard to expand our area. However, we're not in this location yet. So sorry about this, we'd still love to have you as a customer.")?></p>
  <a href="<?php echo Yii::app()->createUrl("/")?>" class="btn btn-green w25">Go home</a>
</div>
 
</div>  -->
<!--container-->

<!-- </template> -->
<!--NO RESULTS END-->


</div> <!--container-->

<!-- end vue-feed -->

<script type="text/x-template" id="xtemplate_banner">   
   <template v-if="loading">
      <el-skeleton animated >
         <template #template>
            <el-skeleton-item variant="rect" style="height: 180px;width:100%;"  />                           
         </template>
      </el-skeleton>
   </template>
   <div class="swiper swiperBanner" ref="refSwiper">
      <div class="swiper-wrapper">  
         <template v-for="items in data">           
            <div class="swiper-slide swiperSlide" type="button" @click="onBannerClick(items)">
               <el-image :fit="cover" class="radius10 none" :src="items.image" ></el-image>
            </div>
         </template>
      </div>      
      <div class="swiper-pagination"></div>
   </div> 
</script>

<div class="container-fluid m-0 p-0 full-width">
 <?php if(isset(Yii::app()->params['settings']['enabled_signup_section'])):?>
 <?php if(Yii::app()->params['settings']['enabled_signup_section']==1 && $enabled_registration==1):?>
    <?php $this->renderPartial("//store/join-us")?>
 <?php endif?>
  <?php endif?>
</div>


<div id="vue-home-widgets" class="container">  
  <components-swiper-list
    ref="ref_swiperlist"
    query="best_seller"         
    title="<?php echo t("Best Seller Restaurants")?>"    
  >
  </components-swiper-list>  
</div>

<?php
$this->renderPartial("//components/template_swiper_list");
?>