

<div id="vue-feed" class="container p-2">
  <h4 class="m-0"><?php echo $model->cuisine_name?></h4>
  <h6 class="m-0" v-cloak >{{this.total_message}}</h6>
  <div class="p-2"></div>  
  
  <template v-if="!hasData && !is_loading">
	<div v-if="hasFilter" style="min-height:400px;">
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
          
          <div class="font-weight-light truncate mb-1" v-html="items.cuisines"></div>
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

</div>