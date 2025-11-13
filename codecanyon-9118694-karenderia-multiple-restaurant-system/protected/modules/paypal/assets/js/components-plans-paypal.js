const componentsplansPaypal={props:["title","label","ajax_url","payment_id","client_id","subscription_type"],data(){return{loading:false,error:[],modal:false}},methods:{subscribe(){this.modal=true;let t="YII_CSRF_TOKEN="+$("meta[name=YII_CSRF_TOKEN]").attr("content");t="&payment_id="+payment_id;axios({method:"POST",url:this.ajax_url+"/createSubscriptions",data:t}).then(t=>{if(t.data.code==1){let a=t.data.details.price_id;let i=t.data.details.callback_url;document.getElementById("paypal-button-container").innerHTML="";paypal.Buttons({createSubscription:function(t,e){return e.subscription.create({plan_id:a})},onApprove:function(t,e){window.location.href=i+"&subscription_id="+t.subscriptionID}}).render("#paypal-button-container")}else{this.$emit("errorMessage",t.data.msg)}}).catch(t=>{}).then(t=>{})},updatesubscriptions(){console.log("updatesubscriptions");this.$emit("showLoader");let t="YII_CSRF_TOKEN="+$("meta[name=YII_CSRF_TOKEN]").attr("content");t="&payment_id="+payment_id;axios({method:"POST",url:this.ajax_url+"/updatesubscriptions",data:t}).then(e=>{if(e.data.code==1){let t=e.data.details.next_actions;if(t=="subscribe"){this.subscribe()}else{window.location.href=e.data.details.redirect_url}}else{this.$emit("errorMessage",e.data.msg)}}).catch(t=>{}).then(t=>{this.$emit("closeLoader")})}},template:`	
     <el-dialog
        v-model="modal"
        title="Paypal"        
        align-center
    >
      <div v-loading="loading">
          <div id="paypal-button-container"></div>
      </div>      
    </el-dialog>	
	`};