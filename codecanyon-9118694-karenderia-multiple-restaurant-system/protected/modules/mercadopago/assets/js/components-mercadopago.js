const componentsMercadopago={props:["title","label","payment_code","merchant_id","merchant_type","public_key","amount","currency_code","ajax_url","cart_uuid","on_error"],data(){return{loading:false,modal:false,first_name:"",last_name:"",email_address:"",identification_type:"",identification_number:"",identification_list:null,loading_data:false}},methods:{getIdentificationList(){this.loading_data=true;let e="merchant_id="+this.merchant_id+"&merchant_type="+this.merchant_type;axios.get(this.ajax_url+"/getIdentificationList?"+e).then(e=>{if(e.data.code==1){this.identification_list=e.data.details.data;this.identification_type=e.data.details.default}}).catch(e=>{console.error("Error:",e)}).then(e=>{this.loading_data=false})},showPaymentForm(e){if(!this.identification_list){this.getIdentificationList()}this.modal=true},addPayment(){this.loading=true;let e="first_name="+this.first_name;e+="&last_name="+this.last_name;e+="&email_address="+this.email_address;e+="&identification_type="+this.identification_type;e+="&identification_number="+this.identification_number;e+="&merchant_id="+this.merchant_id;e+="&YII_CSRF_TOKEN="+$("meta[name=YII_CSRF_TOKEN]").attr("content");axios.post(this.ajax_url+"/addPayment?language="+language,e).then(e=>{if(e.data.code==1){this.modal=false;this.$emit("setPaymentlist")}else{ElementPlus.ElNotification({title:"",message:e.data.msg,position:"bottom-right",type:"warning"})}}).catch(e=>{}).then(e=>{this.loading=false})},PaymentRender(e){console.debug("PaymentRender",e);window.location.href=e.force_payment_data.payment_url},Dopayment(e){window.location.href=this.ajax_url+"/processpayment?data="+e}},template:`		        	 	 	  
	<el-dialog
		v-model="modal"
		:title="title"
		width="500"		
		id="footer-none-bg"		
	>	
	  <div class="mb-2">{{label.notes}}</div>


	   <el-form
		label-position="left"
		label-width="auto"
		:model="formLabelAlign"
		style="max-width: 600px"
		v-loading="loading_data" 
	  >

	    <el-form-item :label="label.first_name" label-position="left">
          <el-input v-model="first_name"></el-input>
        </el-form-item>
		<el-form-item :label="label.last_name" label-position="left">
          <el-input v-model="last_name"></el-input>
        </el-form-item>
		<el-form-item :label="label.email_address" label-position="left" class="is-required asterisk-left">
          <el-input v-model="email_address"></el-input>
        </el-form-item>

		<el-form-item :label="label.identification_type" label-position="left" >
		<el-select
		v-model="identification_type"
		placeholder="Select"
		size="large"		
		>			
		
		<el-option
        v-for="item in identification_list"
        :key="item.id"
        :label="item.name"
        :value="item.id"
        >
		</el-option>

		</el-select>
		</el-form-item>

		<el-form-item :label="label.identification_number" label-position="left">
          <el-input v-model="identification_number"></el-input>
        </el-form-item>

	  </el-form>

	  <template #footer>
	     <div class="dialog-footer" >		 
	       <el-button @click="modal = false" :disabled="loading_data">{{label.cancel}}</el-button>
		   <el-button type="primary" :loading="loading" @click="addPayment" :disabled="loading_data">
              {{label.submit}}
           </el-button>
		 </div>
	  </template>
	</el-dialog>
	`};