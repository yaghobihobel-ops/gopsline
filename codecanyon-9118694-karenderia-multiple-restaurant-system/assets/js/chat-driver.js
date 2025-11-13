import{initializeApp}from"https://www.gstatic.com/firebasejs/9.9.3/firebase-app.js";import{getFirestore,onSnapshot,collection,doc,getDocs,getDoc,query,orderBy,limit,where,Timestamp,addDoc,setDoc,updateDoc,serverTimestamp,deleteDoc}from"https://www.gstatic.com/firebasejs/9.9.3/firebase-firestore.js";import"https://cdn.jsdelivr.net/npm/emoji-picker-element@^1/index.js";import insertText from"https://cdn.jsdelivr.net/npm/insert-text-at-cursor@0.3.0/index.js";import WaveSurfer from"https://cdn.jsdelivr.net/npm/wavesurfer.js@7/dist/wavesurfer.esm.js";import RecordPlugin from"https://cdn.jsdelivr.net/npm/wavesurfer.js@7/dist/plugins/record.esm.js";var empty=function(e){if(typeof e==="undefined"||e==null||e==""||e=="null"||e=="undefined"){return true}return false};let $fc=JSON.parse(firebase_configuration);const firebaseConfig={apiKey:$fc.firebase_apikey,authDomain:$fc.firebase_domain,projectId:$fc.firebase_projectid,storageBucket:$fc.firebase_storagebucket,messagingSenderId:$fc.firebase_messagingid,appId:$fc.firebase_appid};const firebaseCollectionEnum={chats:"chats",limit:20};const firebaasApp=initializeApp(firebaseConfig);const firebaseDb=getFirestore(firebaasApp);const quasarComponents={empty(e){if(typeof e==="undefined"||e===null||e===""||e==="null"||e==="undefined"){return true}return false},setStorage(e,t){try{Quasar.LocalStorage.set(e,t)}catch(e){console.debug(e)}},getStorage(e){return Quasar.LocalStorage.getItem(e)},notify(e,t,i){const s=Quasar.Notify;s.create({message:t,color:e,icon:i,position:"bottom",html:true,timeout:3e3,multiLine:false,actions:[{noCaps:true,color:"white",handler:()=>{}}]})}};const DateTime=luxon.DateTime;const LuxonSettings=luxon.Settings;var empty=function(e){if(typeof e==="undefined"||e==null||e==""||e=="null"||e=="undefined"){return true}return false};const AudioPlayback={name:"AudioPlayback",props:["audio_path","show_media","layout","uploading_status"],data(){return{wavesurfer:null,is_playback:false,duration:null,current_time:null,file_complete_loading:false,file_percent:null,file_error:false}},mounted(){this.initWave()},unmounted(){if(this.wavesurfer){this.wavesurfer.destroy()}},computed:{getPlayTime(){if(!this.is_playback){return this.duration}return this.current_time},formattedTime(){const e=Math.floor(this.timer/60);const t=this.timer%60;return`${String(e).padStart(2,"0")}:${String(t).padStart(2,"0")}`}},watch:{audio_path(e,t){if(!empty(e)){this.wavesurfer.load(e);setTimeout(()=>{},100)}}},methods:{initWave(){try{this.wavesurfer=WaveSurfer.create({container:this.$refs.ref_waveform,waveColor:this.layout==1?"#ffffff":"#4F4A85",progressColor:this.layout==1?"#ffffff":"#383351",barWidth:2,barGap:1,barRadius:1,height:40});if(this.audio_path){this.wavesurfer.load(this.audio_path);setTimeout(()=>{},100)}this.wavesurfer.on("load",e=>{this.file_complete_loading=false});this.wavesurfer.on("error",e=>{console.error("Error loading audio:",e);this.file_complete_loading=true;this.file_error=true});this.wavesurfer.on("loading",e=>{this.file_percent=e});this.wavesurfer.on("ready",e=>{this.duration=this.formatTime(e);this.file_complete_loading=true});this.wavesurfer.on("timeupdate",e=>{this.current_time=this.formatTime(e)});this.wavesurfer.on("play",()=>{this.is_playback=true});this.wavesurfer.on("pause",()=>{this.is_playback=false})}catch(e){}},PlayMedia(){this.wavesurfer.playPause()},formatTime(e){const t=Math.floor(e/60);const i=Math.floor(e%60);return`${t}:${i.toString().padStart(2,"0")}`}},template:`    
  <div class="hidden">
  <div>file_complete_loading=>{{ file_complete_loading }}</div>
  <div>file_percent=>{{ file_percent }}</div>
  <div>audio_path=>{{ audio_path }}</div>
</div>
<div class="relative-position">
  <div
    class="row items-center q-gutter-x-sm"
    :class="{ hidden: !show_media }"
  >
    <div class="col-2">
      <template v-if="!file_complete_loading">
        <q-spinner :color="layout == 1 ? 'white' : 'green'" size="2.5em" />
      </template>
      <template v-else>
        <template v-if="file_error">
          <q-btn
            flat
            icon="error_outline"
            :color="layout == 1 ? 'white' : 'dark'"
          ></q-btn>
        </template>
        <template v-else>
          <q-btn
            flat
            rounded
            :icon="
              is_playback
                ? 'pause'
                : 'play_arrow'
            "
            size="18px"
            @click="PlayMedia"
            dense
            :color="layout == 1 ? 'white' : 'dark'"
          ></q-btn>
        </template>
      </template>
    </div>
    <div class="col">
      <template v-if="file_error"> </template>        
      <div ref="ref_waveform" style="height: 40px"></div>
    </div>
    <div
      class="col-2"
      :class="{ 'text-white': layout == 1, 'text-dark': layout == 2 }"
    >
      {{ getPlayTime }}
    </div>
  </div>
</div>
  `};const AudioRecorder={components:{audioplayback:AudioPlayback},data(){return{is_recording:false,audioPath:null,audioBase64:null,has_permission:false,timer:0,interval:null,duration:null,current_time:null,is_playback:false,is_uploading:false,mimeType:null,testData:null,recordingStatus:null,wavesurfer:null,record:null,record_progress:null,cancel_recording:false,maxRecordingDuration:1*60*1e3}},mounted(){this.initWaveform()},computed:{showMedia(){if(!this.is_recording&&this.hasAudio&&!this.is_uploading){return true}return false},formattedTime(){return this.record_progress?this.record_progress:"00:00"},hasAudio(){if(!empty(this.audioBase64)){return true}return false},getPlayTime(){if(!this.is_playback){return this.duration}return this.current_time}},methods:{async initWaveform(){if(this.wavesurfer){this.wavesurfer.destroy()}this.is_uploading=false;this.wavesurfer=WaveSurfer.create({container:this.$refs.ref_mic,waveColor:"#4F4A85",progressColor:"#383351",barWidth:2,barGap:1,barRadius:1,height:40});let e=false;let t=true;this.record=this.wavesurfer.registerPlugin(RecordPlugin.create({renderRecordedAudio:false,scrollingWaveform:e,continuousWaveform:t,continuousWaveformDuration:30}));this.record.on("record-end",async e=>{this.mimeType=e.type;this.audioPath=URL.createObjectURL(e);this.audioBase64=await this.blobToBase64(e)});this.record.on("record-start",()=>{console.log("Recording started...",this.maxRecordingDuration);setTimeout(()=>{this.toogleRecording();console.log("Recording stopped automatically after 10 seconds.")},this.maxRecordingDuration)});this.record.on("record-progress",e=>{const t=[Math.floor(e%36e5/6e4),Math.floor(e%6e4/1e3)].map(e=>e<10?"0"+e:e).join(":");this.record_progress=t});setTimeout(()=>{this.toogleRecording()},1e3)},blobToBase64(e){return new Promise((t,i)=>{const s=new FileReader;s.onloadend=()=>{const e=s.result.split(",")[1];t(e)};s.onerror=e=>i(e);s.readAsDataURL(e)})},toogleRecording(){this.is_uploading=false;if(this.record.isRecording()||this.record.isPaused()){console.log("stop recording");this.is_recording=false;this.record.stopRecording();return}const e="";this.record.startRecording({deviceId:e}).then(()=>{console.log("start recording");this.is_recording=true})},PauseResumeRecording(){console.log("PauseResumeRecording",this.is_recording);if(this.record.isRecording()){console.log("pause recording");this.is_recording=false;this.record.pauseRecording()}else if(this.record.isPaused()){console.log("resume recording");this.is_recording=true;this.record.resumeRecording()}},stopRecording(){console.log("stopRecording");if(this.record.isRecording()||this.record.isPaused()){this.is_recording=false;this.record.stopRecording()}this.$emit("cancelRecording")},async UploadAudio(){console.log("UploadAudio");if(this.record.isRecording()||this.record.isPaused()){this.is_recording=false;this.record.stopRecording()}this.is_uploading=true;setTimeout(()=>{this.$emit("startUpload",this.audioPath,this.audioBase64,this.mimeType)},500)}},template:`      
  <audioplayback
    :audio_path="audioPath"
    :show_media="showMedia"
    layout="2"
  ></audioplayback>

  <div
    class="text-center text-subtitle1 flex flex-center"
    style="height: 50px"
    :class="{ hidden: showMedia }"
  >    
     <div class="row full-width items-center">
       <div class="col-2">
           {{ formattedTime }}
       </div>
       <div class="col">
          <div ref="ref_mic" style="height: 40px;" class="full-width"></div>
       </div>
     </div>
  </div>

  <div class="row items-center text-center">
    <div class="col-2 borderx">
      <q-btn
        icon="delete_outline"
        size="md"
        flat
        round
        @click="stopRecording"
      ></q-btn>
    </div>
    <div class="col borderx">
      <q-btn
        :icon="is_recording ? 'pause' : 'mic'"
        color="red"
        size="md"
        flat
        round
        @click="toogleRecording"
      ></q-btn>
    </div>
    <div class="col-2 borderx">
      <q-btn
        color="green"
        icon="send"
        no-caps
        size="md"
        class="text-weight-bold"
        round
        unelevated
        @click="UploadAudio"
      >
      </q-btn>
    </div>
  </div>
  `};const componentsChat={props:["api","api_upload","user_uuid","conversation_id","label","max_file_size","from_data","to_data"],components:{AudioRecorder:AudioRecorder},data(){return{message:"",files:{},file_url:"",file_type:"",upload_loading:false,loading:false,is_typing:false,is_recording:false,audioPath:null,audioBase64:null,mimeType:null,upload_response:null,upload_audio_loading:false}},computed:{hasConversation(){if(!empty(this.conversation_id)){return true}return false},hasMessage(){if(!empty(this.message)){return true}if(Object.keys(this.files).length>0){return true}return false}},watch:{conversation_id(e,t){this.message=""},message(e,t){if(!this.is_typing){setTimeout(()=>{this.is_typing=false},1e3)}this.is_typing=true}},methods:{onSubmit(){if(!this.hasMessage){this.checkPermissionAndStartAudio();return}if(Object.keys(this.files).length>0){this.$refs.uploader.upload()}else{this.saveChatMessage()}},async checkPermissionAndStartAudio(){this.is_recording=true},cancelRecording(){this.is_recording=false},async saveChatMessage(){this.loading=true;const e=collection(firebaseDb,firebaseCollectionEnum.chats,this.conversation_id,"messages");try{await addDoc(e,{message:this.message,senderID:this.user_uuid,timestamp:Timestamp.now(),serverTimestamp:serverTimestamp(),fileUrl:this.file_url,fileType:this.file_type,sender:this.from_data.name,photo:this.from_data.avatar});this.loading=false;this.documentLastUpdate(this.conversation_id);this.resetChat();this.$emit("afterAddmessage")}catch(e){console.error("Error adding message to the conversation:",e);quasarComponents.notify("red-5",e,"error_outline")}},async documentLastUpdate(e){try{const t=doc(firebaseDb,firebaseCollectionEnum.chats,e);await updateDoc(t,{lastUpdated:serverTimestamp()})}catch(e){quasarComponents.notify("red-5",e,"error_outline")}},resetChat(){this.message="";this.file_url="";this.file_type="";this.files={};this.$refs.uploader.reset()},pickFiles(){this.$refs.uploader.pickFiles()},onRejectedFiles(e){quasarComponents.notify("red-5","Invalid file type","error_outline")},afterAddedFiles(e){Object.entries(e).forEach(([e,t])=>{this.files[t.name]={name:t.name}})},afterRemoveFiles(e){Object.entries(e).forEach(([e,t])=>{delete this.files[t.name]})},onUploadingFiles(e){this.upload_loading=true},afterUploaded(r){if(r.xhr.status==200){let e=JSON.parse(r.xhr.response);let t=e.code||false;let i=e.details||[];let s=e.msg||"";if(t==1){this.file_url=i.file_url;this.file_type=i.file_type;this.saveChatMessage()}else{quasarComponents.notify("red-5",s,"error_outline");this.$refs.uploader.reset()}}else{quasarComponents.notify("red-5","Error uploading files","error_outline");this.$refs.uploader.reset()}},afterFinishUpload(){this.upload_loading=false},showEmoji(){document.querySelector("emoji-picker").addEventListener("emoji-click",e=>{insertText(document.querySelector("textarea"),e.detail.unicode)})},async UpdateWhoistyping(e){try{const t=doc(firebaseDb,firebaseCollectionEnum.chats,this.conversation_id);await updateDoc(t,{[`isTyping.${this.user_uuid}`]:e})}catch(e){console.error("Error updating typing status:",e)}},async startUpload(e,t,i){this.is_recording=false;this.audioPath=e;this.audioBase64=t;this.mimeType=i;try{if(!this.audioBase64){console.error("No audio file to upload");return}this.upload_audio_loading=true;const s={audioBase64:this.audioBase64,fileName:`recording_${Date.now()}.webm`};const r=await axios.post(`${ajaxurl}/uploadaudio`,s,{headers:{"Content-Type":"application/json"}});console.log("response",r);this.upload_audio_loading=false;this.upload_response=r.data;if(r.data.code==1){this.saveChatAudio()}else{quasarComponents.notify("red-5",r.data.msg,"error_outline")}}catch(e){this.upload_response="Failed to upload audio =>"+e.message}},async saveChatAudio(){console.log("saveChatAudio");try{this.loading=true;const e=collection(firebaseDb,firebaseCollectionEnum.chats,this.conversation_id,"messages");await addDoc(e,{messageType:"audio",message:this.message,senderID:this.user_uuid,timestamp:Timestamp.now(),serverTimestamp:serverTimestamp(),fileUrl:this.upload_response.details.file_url,fileType:this.mimeType,sender:this.from_data.name,photo:this.from_data.avatar});this.loading=false;this.documentLastUpdate(this.conversation_id);this.resetChat();this.$emit("afterAddmessage")}catch(e){console.error("Error adding message to the conversation:",e)}}},template:`     
    <div class="full-width border-grey radius10">
    <div class="q-pl-sm q-pr-sm">      
      <q-inner-loading
        :showing="upload_loading"
        color="primary"
        :label="label.please_wait"
        label-class="text-dark"
        label-style="font-size: 1em"
      >
      </q-inner-loading>

      <template v-if="is_recording">
        <div class="q-pa-sm">        
          <AudioRecorder
            ref="ref_audio"
            @cancel-recording="cancelRecording"
            @start-upload="startUpload"
          ></AudioRecorder>
        </div>
      </template>
       <template v-else>
  
      <q-uploader            
        :url="api_upload"            
        multiple
        ref="uploader"
        flat                  
        accept=".jpg, image/*"
        :max-total-size="max_file_size"
        field-name="file"            
        @added="afterAddedFiles"        
        @removed="afterRemoveFiles"   
        @rejected="onRejectedFiles"                        
        @uploading="onUploadingFiles"   
        @uploaded="afterUploaded" 
        @finish="afterFinishUpload"
        >
        <template v-slot:header="scope">         
          <q-uploader-add-trigger ></q-uploader-add-trigger>
        </template>
        <template v-slot:list="scope">
            <div class="flex justify-start q-col-gutter-x-md">
              <template v-for="file in scope.files" :key="file.__key">
                <div class="relative-position">
                    <img :src="file.__img.src" style="max-width: 60px; height:60px;" class="radius10"></img>
                    <div class="absolute-right" style="margin-right: -10px;margin-top: -5px;">
                      <q-btn 
                      unelevated 
                      round color="primary" 
                      icon="close" 
                      size="xs"
                      @click="scope.removeFile(file)"
                      ></q-btn>
                    </div>
                </div>            
              </template>
            </div>
        </template>
    </q-uploader>
  
      <q-input color="primary" 
      v-model="message"
      :label="label.your_message"      
      ref="message"      
      autogrow
      borderless             
      >
        <template v-slot:append>
          <div class="q-gutter-sm">
  
            <q-btn unelevated round color="mygrey" text-color="grey"  @click="pickFiles"  >
              <q-icon name="attach_file" class="rotate-45"></q-icon>
            </q-btn>
  
            <q-btn unelevated round color="mygrey" text-color="grey"  >
              <q-icon name="emoji_emotions" ></q-icon>
              <q-popup-proxy @show="showEmoji">
                 <q-card>
                 <emoji-picker ref="emoji"></emoji-picker>
                 </q-card>
              </q-popup-proxy>
            </q-btn>               
         
            
            <q-btn    
            @click="onSubmit"                          
            :loading="loading"
            color="green"
            :icon="hasMessage ? 'send' : 'mic'"
            no-caps 
            size="md"
            round
            unelevated
            >
            </q-btn>                  
  
          </div>
        </template>
      </q-input>        
      </template>
  
    </div>
    </div>           
    `};const app_chat=Vue.createApp({components:{"components-chat":componentsChat,audioplayback:AudioPlayback},data(){return{data:[],conversation_id:null,loading_create:false,loading:true,user_uuid:null,driver_uuid:null,from_data:null,to_data:null,unsubMessages:null,driver_info:null,audioPath:null,audioBase64:null,mimeType:null,upload_response:null,upload_audio_loading:false}},created(){if(typeof main_user_uuid!=="undefined"&&main_user_uuid!==null){this.user_uuid=main_user_uuid}if(typeof driver_uuid!=="undefined"&&driver_uuid!==null){this.driver_uuid=driver_uuid}if(typeof from_data!=="undefined"&&from_data!==null){this.from_data=JSON.parse(from_data)}if(typeof to_data!=="undefined"&&to_data!==null){this.to_data=JSON.parse(to_data)}if(typeof order_uuid!=="undefined"&&order_uuid!==null){if(!empty(order_uuid)){this.getConversation()}}},computed:{getChatmessage(){return this.data},hasMessage(){if(Object.keys(this.data).length>0){return true}return false}},unmounted(){if(this.unsubMessages){this.unsubMessages()}},mounted(){if(!this.driver_info){this.getDriverInfo()}},methods:{getDriverInfo(){axios.get(ajaxurl+"/getDriverInfo?driver_uuid="+this.driver_uuid).then(e=>{if(e.data.code==1){this.driver_info=e.data.details.data}}).catch(e=>{console.error("Error:",e)}).then(e=>{})},async getConversation(){console.log("getConversation",order_uuid);const e=doc(firebaseDb,firebaseCollectionEnum.chats,order_uuid);const t=await getDoc(e);if(t.exists()){this.getMessages(order_uuid)}else{this.createChatOrder()}},async createChatOrder(){try{console.log("createChatOrder");this.loading_create=true;let e={lastUpdated:serverTimestamp(),dateCreated:serverTimestamp(),orderID:order_id,orderUuid:order_uuid,participants:[driver_uuid,main_user_uuid],isTyping:{[`${driver_uuid}`]:false,[`${main_user_uuid}`]:false},from_info:this.from_data,to_info:this.to_data};await setDoc(doc(firebaseDb,firebaseCollectionEnum.chats,order_uuid),e);this.loading_create=false;this.getMessages(order_uuid)}catch(e){console.error("Error creating chat order:");console.error("Error message:",e.message);console.error("Error code:",e.code)}},getMessages(e){console.log("getMessages",e);this.conversation_id=e;this.loading=true;const t=doc(firebaseDb,firebaseCollectionEnum.chats,e);const i=query(collection(t,"messages"),orderBy("serverTimestamp","asc"),limit(firebaseCollectionEnum.limit));if(this.unsubMessages){this.unsubMessages()}this.unsubMessages=onSnapshot(i,e=>{this.data=[];this.loading=false;e.forEach(t=>{if(t.exists()){const i=t.data();let e=i.timestamp.toDate().toISOString();this.data.push({messageType:i.messageType,fileType:i.fileType,fileUrl:i.fileUrl,message:i.message,senderID:i.senderID,sender:i.sender,photo:i.photo,time:DateTime.fromISO(e).toFormat("ccc hh:mm a"),timestamp:e})}else{console.log("Conversation document does not exist")}});this.scrollTobottom()},e=>{this.loading=false;console.error("Error fetching messages:",e);quasarComponents.notify("red-5",e,"error_outline")})},afterAddmessage(){this.scrollTobottom();this.notifyUser()},scrollTobottom(){setTimeout(()=>{if(typeof this.$refs.scroll_ref!=="undefined"&&this.$refs.scroll_ref!==null){let e=parseInt(this.$refs.scroll_ref.getScroll().verticalSize)+100;this.$refs.scroll_ref.setScrollPosition("vertical",e)}},500)},notifyUser(){let e="to="+this.driver_uuid+"&from="+this.user_uuid;e+="&first_name="+this.to_data.first_name;e+="&last_name="+this.to_data.last_name;e+="&conversation_id="+this.conversation_id;e+="&avatar="+this.to_data.avatar;axios.get(chat_api+"/notifyChatUser?"+e).then(e=>{if(e.data.code==1){}else{}}).catch(e=>{console.error("Error:",e)}).then(e=>{})}}});app_chat.use(Quasar,{config:{notify:{},loadingBar:{skipHijack:true},loading:{}}});app_chat.mount("#app-driver-chat");