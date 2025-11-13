import{initializeApp}from"https://www.gstatic.com/firebasejs/9.9.3/firebase-app.js";import{getFirestore,onSnapshot,collection,doc,getDocs,getDoc,query,orderBy,limit,where,Timestamp,addDoc,setDoc,updateDoc,serverTimestamp,deleteDoc}from"https://www.gstatic.com/firebasejs/9.9.3/firebase-firestore.js";import"https://cdn.jsdelivr.net/npm/emoji-picker-element@^1/index.js";import insertText from"https://cdn.jsdelivr.net/npm/insert-text-at-cursor@0.3.0/index.js";import WaveSurfer from"https://cdn.jsdelivr.net/npm/wavesurfer.js@7/dist/wavesurfer.esm.js";import RecordPlugin from"https://cdn.jsdelivr.net/npm/wavesurfer.js@7/dist/plugins/record.esm.js";var empty=function(e){if(typeof e==="undefined"||e==null||e==""||e=="null"||e=="undefined"){return true}return false};let $fc=JSON.parse(firebase_configuration);const firebaseConfig={apiKey:$fc.firebase_apikey,authDomain:$fc.firebase_domain,projectId:$fc.firebase_projectid,storageBucket:$fc.firebase_storagebucket,messagingSenderId:$fc.firebase_messagingid,appId:$fc.firebase_appid};const firebaseCollectionEnum={chats:"chats",limit:500};const firebaasApp=initializeApp(firebaseConfig);const firebaseDb=getFirestore(firebaasApp);const quasarComponents={empty(e){if(typeof e==="undefined"||e===null||e===""||e==="null"||e==="undefined"){return true}return false},setStorage(e,t){try{Quasar.LocalStorage.set(e,t)}catch(e){console.debug(e)}},getStorage(e){return Quasar.LocalStorage.getItem(e)},notify(e,t,s){const i=Quasar.Notify;i.create({message:t,color:e,icon:s,position:"bottom",html:true,timeout:3e3,multiLine:false,actions:[{noCaps:true,color:"white",handler:()=>{}}]})}};const DateTime=luxon.DateTime;const LuxonSettings=luxon.Settings;const componentsTest={props:["api"],created(){},computed:{},methods:{},template:`
    test 
    `};const componentsUserSkeleton={props:["rows"],template:`
    <q-list >
      <q-item v-for="items in rows" :key="items">
        <q-item-section avatar>
          <q-skeleton type="QAvatar" />
        </q-item-section>
        <q-item-section>
          <q-item-label>
            <q-skeleton type="text" />
          </q-item-label>
          <q-item-label caption>
            <q-skeleton type="text" />
          </q-item-label>
         </q-item-section>
      </q-item>
    </q-list>    
    `};const componentsParticipants={props:["api","user_uuid","language","label","main_user_type"],components:{"components-loader":componentsUserSkeleton},data(){return{data:[],users:[],all_users:[],users_data:[],loading:false,loading_user:false,last_message_data:{},whoistyping_data:{},document_id:""}},created(){this.getParticipants()},computed:{getData(){return this.data},getLastMessageData(){return this.last_message_data},hasData(){if(Object.keys(this.data).length>0){return true}return false},hasUserData(){if(Object.keys(this.users_data).length>0){return true}return false},getShowistyping(){return this.whoistyping_data}},watch:{},methods:{getParticipants(){this.loading=true;const e=collection(firebaseDb,firebaseCollectionEnum.chats);const t=query(e,where("participants","array-contains",this.user_uuid),orderBy("lastUpdated","desc"),limit(firebaseCollectionEnum.limit));const s=onSnapshot(t,e=>{this.data=[];this.users=[];this.all_users=[];this.loading=false;e.forEach(e=>{let t=e.data();let s=t.isTyping||null;let i=t.participants||null;if(Object.keys(i).length>0){Object.entries(i).forEach(([e,t])=>{this.all_users.push(t)})}let a=i.filter(e=>!e.includes(this.user_uuid));let r=a[0]?a[0]:null;let o=null;let n=t.from_info||null;let l=t.to_info||null;if(n&&n.client_uuid===this.user_uuid){o=l}else if(l&&l.client_uuid===this.user_uuid){o=n}this.users.push(r);this.data.push({doc_id:e.id,user_uuid:r,is_typing:s[a[0]]?s[a[0]]:false,orderID:t.orderID||null,orderUuid:t.orderUuid||null,to_info:o})});if(Object.keys(this.users).length>0){this.getLastMessage()}},e=>{this.loading=false;console.log("Error fetching chat documents:",e)})},getUser(){this.loading_user=true;axios({method:"post",url:this.api+"/getUsers?language="+this.language,data:{main_user_type:this.main_user_type,users:this.users}}).then(e=>{if(e.data.code==1){this.users_data=e.data.details}else{this.users_data=[]}this.$emit("setUserdata",this.users_data)}).catch(e=>{}).then(e=>{this.loading_user=false})},async getLastMessage(){try{if(Object.keys(this.users).length>0){const a=this.users.splice(0,10);const e=collection(firebaseDb,firebaseCollectionEnum.chats);const t=await getDocs(query(e,where("participants","array-contains-any",a)));t.forEach(async e=>{const i=e.id;const t=collection(firebaseDb,firebaseCollectionEnum.chats,i,"messages");const s=await getDocs(query(t,where("senderID","in",a),orderBy("timestamp","desc"),limit(1)));s.forEach(e=>{let t=e.data();let s=t.timestamp.toDate().toISOString();this.last_message_data[i]={message:t.message,timestamp:s,time:DateTime.fromISO(s).toFormat("hh:mm a")}})})}}catch(e){console.error("Error fetching last message:",e)}},async getWhoIsTyping(){if(Object.keys(this.users).length>0){const e=this.users.splice(0,10);const t=query(collection(firebaseDb,firebaseCollectionEnum.chats),where("participants","array-contains-any",e),limit(firebaseCollectionEnum.limit));const s=onSnapshot(t,e=>{e.forEach(e=>{let t=e.data();let s=t.isTyping||[];if(Object.keys(s).length>0){Object.entries(s).forEach(([e,t])=>{this.whoistyping_data[e]=t})}})})}},isTyping(t){if(Object.keys(this.whoistyping_data).length>0){let e=this.whoistyping_data[t]||false;return e}return false},onClickChat(e){this.document_id=e;this.$emit("afterClickconversation",e)}},template:`            
    <template v-if="loading">
       <components-loader :rows="10"></components-loader>
    </template> 
    
    <template v-if="hasData && !loading">  
        <q-list class="list-custom">
            <template v-for="items in getData" :key="items">                
            <template v-if="items.to_info">
                <q-item clickable v-ripple @click="onClickChat(items.doc_id)" :active="items.doc_id==document_id" active-class="bg-mygrey text-grey-8 q-mb-sm" >        
                   <q-item-section avatar>
                    <q-avatar>                                       
                      <img :src="items.to_info.photo"></img>
                    </q-avatar>
                   </q-item-section>
                   <q-item-section>
                      <q-item-label class="text-weight-bold">
                          {{ items.to_info.first_name }} {{ items.to_info.last_name }}
                       </q-item-label>
                       
                       <q-item-label caption>
                          <template v-if="items.orderID">
                              {{label.order_number}} {{items.orderID}}
                          </template>
                          <template v-else>
                              {{ items.to_info.user_type }}
                          </template>                       
                        </q-item-label>

                        <q-item-label caption lines="2" v-if="getLastMessageData[items.doc_id]">
                           <template v-if="items.is_typing">
                               <span class="text-primary"> {{ label.is_typing }} ...</span>
                          </template>
                          <template v-else>
                            {{ getLastMessageData[items.doc_id].message }}
                          </template>
                        </q-item-label>
                   </q-item-section>
                </q-item>
            </template>
            </template>
        </q-list>
    </template>                    
    `};const AudioPlayback={name:"AudioPlayback",props:["audio_path","show_media","layout","uploading_status"],data(){return{wavesurfer:null,is_playback:false,duration:null,current_time:null,file_complete_loading:false,file_percent:null,file_error:false}},mounted(){this.initWave()},unmounted(){if(this.wavesurfer){this.wavesurfer.destroy()}},computed:{getPlayTime(){if(!this.is_playback){return this.duration}return this.current_time},formattedTime(){const e=Math.floor(this.timer/60);const t=this.timer%60;return`${String(e).padStart(2,"0")}:${String(t).padStart(2,"0")}`}},watch:{audio_path(e,t){if(!empty(e)){this.wavesurfer.load(e);setTimeout(()=>{},100)}}},methods:{initWave(){try{this.wavesurfer=WaveSurfer.create({container:this.$refs.ref_waveform,waveColor:this.layout==1?"#ffffff":"#4F4A85",progressColor:this.layout==1?"#ffffff":"#383351",barWidth:2,barGap:1,barRadius:1,height:40});if(this.audio_path){this.wavesurfer.load(this.audio_path);setTimeout(()=>{},100)}this.wavesurfer.on("load",e=>{this.file_complete_loading=false});this.wavesurfer.on("error",e=>{console.error("Error loading audio:",e);this.file_complete_loading=true;this.file_error=true});this.wavesurfer.on("loading",e=>{this.file_percent=e});this.wavesurfer.on("ready",e=>{this.duration=this.formatTime(e);this.file_complete_loading=true});this.wavesurfer.on("timeupdate",e=>{this.current_time=this.formatTime(e)});this.wavesurfer.on("play",()=>{this.is_playback=true});this.wavesurfer.on("pause",()=>{this.is_playback=false})}catch(e){}},PlayMedia(){this.wavesurfer.playPause()},formatTime(e){const t=Math.floor(e/60);const s=Math.floor(e%60);return`${t}:${s.toString().padStart(2,"0")}`}},template:`    
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
    `};const componentsMessages={props:["api","user_uuid","conversation_id","user_data","label","no_chat_image_url"],components:{AudioPlayback:AudioPlayback},watch:{conversation_id(e,t){if(!empty(e)){this.getMessages(e);this.getParticipant(e);this.getWhoIsTyping(e)}else{this.data=[];this.user_typing_data=[];this.chating_with_user_uuid=""}}},data(){return{data:[],loading:false,user_typing_data:[],chating_with_user_uuid:"",to_info:null,from_info:null}},computed:{getChatmessage(){return this.data},hasMessage(){if(Object.keys(this.data).length>0){return true}return false},hasChatDocID(){if(!empty(this.chating_with_user_uuid)){return true}return false},hasUserData(){if(Object.keys(this.user_data).length>0){return true}return false},getUserData(){return this.user_data},getUserTyping(){return this.user_typing_data},getChatWith(){let e=null;if(this.from_info&&this.to_info){if(this.from_info.client_uuid===this.user_uuid){e=this.to_info}else if(this.to_info.client_uuid===this.user_uuid){e=this.from_info}}return e}},methods:{getMessages(e){this.loading=true;const t=doc(firebaseDb,firebaseCollectionEnum.chats,e);const s=query(collection(t,"messages"),orderBy("timestamp","asc"),limit(firebaseCollectionEnum.limit));const i=onSnapshot(s,e=>{this.data=[];this.loading=false;e.forEach(t=>{if(t.exists()){const s=t.data();let e=s.timestamp.toDate().toISOString();this.data.push({messageType:s.messageType,fileType:s.fileType,fileUrl:s.fileUrl,message:s.message,senderID:s.senderID,timestamp:e,time:DateTime.fromISO(e).toFormat("ccc hh:mm a"),sender:s.sender,photo:s.photo})}else{console.log("Conversation document does not exist")}});this.$emit("scrollTobottom")},e=>{this.loading=false;console.error("Error fetching messages:",e)})},getWhoIsTyping(e){const t=doc(firebaseDb,firebaseCollectionEnum.chats,e);const s=onSnapshot(t,t=>{if(t.exists()){let e=t.data();this.user_typing_data=e.isTyping||[]}else{this.user_typing_data=[]}this.$emit("scrollTobottom")},e=>{console.error("Error fetching chat document:",e)})},async getParticipant(e){try{const t=doc(firebaseDb,firebaseCollectionEnum.chats,e);const a=await getDoc(t);if(a.exists()){const r=a.data();const o=r.participants||null;this.from_info=r.from_info||null;this.to_info=r.to_info||null;let e=o.filter(e=>!e.includes(this.user_uuid));this.chating_with_user_uuid=e[0]?e[0]:null;let t=null;let s=r.from_info||null;let i=r.to_info||null;if(s&&s.client_uuid===this.user_uuid){t=i}else if(i&&i.client_uuid===this.user_uuid){t=s}this.$emit("setChattingwith",t)}else{console.log("Conversation document does not exist");this.$emit("setChattingwith",null)}}catch(e){console.error("Error getting participants:",e)}}},template:`                     
     <q-inner-loading
        :showing="loading"
        color="primary"
        :label="label.please_wait"
        label-class="text-dark"
        label-style="font-size: 1em"
    >
    </q-inner-loading>    
    
    <!--- START MESSAGES -->        
    
    <template v-for="items in getChatmessage" :key="items">
        <template v-if="items.messageType == 'audio'">
        
          <q-chat-message
            :name="items.senderID == user_uuid ? label.you : items.sender"
            :avatar="items.photo"
            :stamp="items.time"
            :text-color="items.senderID == user_uuid ? 'white' : 'dark'"
            :bg-color="items.senderID == user_uuid ? 'blue' : 'grey-2'"
            :sent="items.senderID == user_uuid ? true : false"
          >
            <template #avatar>
              <q-avatar class="q-ml-sm">
                <q-img
                  :src="items.photo"
                  spinner-size="sm"
                  spinner-color="primary"
                  style="height: 48px; max-width: 48px; min-width: 48px"
                  fit="cover"
                  loading="lazy"
                ></q-img>
              </q-avatar>
            </template>
            <div style="min-width: 300px; max-width: 300px">
              <AudioPlayback
                :audio_path="items.fileUrl"
                :show_media="true"
                :layout="items.senderID == user_uuid ? 1 : 0"
                :uploading_status="upload_audio_loading"
              ></AudioPlayback>
            </div>
          </q-chat-message>

        </template>
        <template v-else>
        <q-chat-message
          :name="items.senderID == user_uuid ? label.you : items.sender"
          :avatar="items.photo"
          :stamp="items.time"
          :text-color="items.senderID == user_uuid ? 'white' : 'dark'"
          :bg-color="items.senderID == user_uuid ? 'blue' : 'grey-2'"
          :sent="items.senderID == user_uuid ? true : false"
        >

            <template #avatar>
                <q-avatar class="q-ml-sm">
                  <q-img
                    :src="items.photo"
                    spinner-size="sm"
                    spinner-color="primary"
                    style="height: 48px; max-width: 48px; min-width: 48px"
                    fit="cover"
                    loading="lazy"
                  ></q-img>
                </q-avatar>
            </template>
            <div v-if="items.message">{{ items.message }}</div>

            <template v-if="items.fileUrl">
            <q-img
              :src="items.fileUrl"
              spinner-size="sm"
              spinner-color="primary"
              style="min-height: 150px; min-width: 150px; max-width: 150px"
            >
            </q-img>
            </template>

        </q-chat-message>
        </template>
    </template>
    <!--- END MESSAGES -->
    
    <template v-if="!hasChatDocID && !loading">
       <div class="text-center q-mt-sm">       
          <q-img
          :src="no_chat_image_url"
          spinner-color="white"
          fit="fill"
          style="height: 120px; max-width: 130px"
         >
         </q-img>
         <h6 class="q-ma-none q-pt-md">{{label.no_chat_selected}}</h6>
       </div>
    </template>

    <!--- START TYPING -->    
    <template v-for="(items, userUUID) in getUserTyping" :key="items">
        <template v-if="items">
            <template v-if="userUUID != user_uuid">
                <template v-if="getChatWith">
                <q-chat-message
                  :name="getChatWith.first_name+' '+label.is_typing"
                  :avatar="getChatWith.photo"
                  :text-color="userUUID == user_uuid ? 'white' : 'dark'"
                  bg-color="amber"
                  :sent="userUUID == user_uuid ? true : false"
                >
                  <q-spinner-dots size="2rem" />
                </q-chat-message>
                 </template>
            </template> 
        </template>      
    </template>
    <!--- END TYPING -->
  `};const AudioRecorder={components:{AudioPlayback:AudioPlayback},data(){return{is_recording:false,audioPath:null,audioBase64:null,has_permission:false,timer:0,interval:null,duration:null,current_time:null,is_playback:false,is_uploading:false,mimeType:null,testData:null,recordingStatus:null,wavesurfer:null,record:null,record_progress:null,cancel_recording:false,maxRecordingDuration:1*60*1e3}},mounted(){this.initWaveform()},computed:{showMedia(){if(!this.is_recording&&this.hasAudio&&!this.is_uploading){return true}return false},formattedTime(){return this.record_progress?this.record_progress:"00:00"},hasAudio(){if(!empty(this.audioBase64)){return true}return false},getPlayTime(){if(!this.is_playback){return this.duration}return this.current_time}},methods:{async initWaveform(){if(this.wavesurfer){this.wavesurfer.destroy()}this.is_uploading=false;this.wavesurfer=WaveSurfer.create({container:this.$refs.ref_mic,waveColor:"#4F4A85",progressColor:"#383351",barWidth:2,barGap:1,barRadius:1,height:40});let e=false;let t=true;this.record=this.wavesurfer.registerPlugin(RecordPlugin.create({renderRecordedAudio:false,scrollingWaveform:e,continuousWaveform:t,continuousWaveformDuration:30}));this.record.on("record-end",async e=>{this.mimeType=e.type;this.audioPath=URL.createObjectURL(e);this.audioBase64=await this.blobToBase64(e)});this.record.on("record-start",()=>{console.log("Recording started...",this.maxRecordingDuration);setTimeout(()=>{this.toogleRecording();console.log("Recording stopped automatically after 10 seconds.")},this.maxRecordingDuration)});this.record.on("record-progress",e=>{const t=[Math.floor(e%36e5/6e4),Math.floor(e%6e4/1e3)].map(e=>e<10?"0"+e:e).join(":");this.record_progress=t});setTimeout(()=>{this.toogleRecording()},1e3)},blobToBase64(e){return new Promise((t,s)=>{const i=new FileReader;i.onloadend=()=>{const e=i.result.split(",")[1];t(e)};i.onerror=e=>s(e);i.readAsDataURL(e)})},toogleRecording(){this.is_uploading=false;if(this.record.isRecording()||this.record.isPaused()){console.log("stop recording");this.is_recording=false;this.record.stopRecording();return}const e="";this.record.startRecording({deviceId:e}).then(()=>{console.log("start recording");this.is_recording=true})},PauseResumeRecording(){console.log("PauseResumeRecording",this.is_recording);if(this.record.isRecording()){console.log("pause recording");this.is_recording=false;this.record.pauseRecording()}else if(this.record.isPaused()){console.log("resume recording");this.is_recording=true;this.record.resumeRecording()}},stopRecording(){console.log("stopRecording");if(this.record.isRecording()||this.record.isPaused()){this.is_recording=false;this.record.stopRecording()}this.$emit("cancelRecording")},async UploadAudio(){console.log("UploadAudio");if(this.record.isRecording()||this.record.isPaused()){this.is_recording=false;this.record.stopRecording()}this.is_uploading=true;setTimeout(()=>{this.$emit("startUpload",this.audioPath,this.audioBase64,this.mimeType)},500)}},template:`    
  
  <AudioPlayback
    :audio_path="audioPath"
    :show_media="showMedia"
    layout="2"
  ></AudioPlayback>

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
  `};const componentsChat={props:["api","api_upload","user_uuid","conversation_id","user_data","label","max_file_size","from_data"],components:{AudioRecorder:AudioRecorder},data(){return{message:"",files:{},file_url:"",file_type:"",upload_loading:false,loading:false,is_typing:false,is_recording:false,audioPath:null,audioBase64:null,mimeType:null,upload_response:null,upload_audio_loading:false}},computed:{hasConversation(){if(!empty(this.conversation_id)){return true}return false},hasMessage(){if(!empty(this.message)){return true}if(Object.keys(this.files).length>0){return true}return false}},watch:{conversation_id(e,t){this.message=""},is_typing(e,t){if(e){this.UpdateWhoistyping(true)}else{this.UpdateWhoistyping(false)}},message(e,t){if(!this.is_typing){setTimeout(()=>{this.is_typing=false},1e3)}this.is_typing=true}},methods:{onSubmit(){if(!this.hasMessage){this.checkPermissionAndStartAudio();return}if(Object.keys(this.files).length>0){this.$refs.uploader.upload()}else{this.saveChatMessage()}},async checkPermissionAndStartAudio(){this.is_recording=true},cancelRecording(){this.is_recording=false},async saveChatMessage(){this.loading=true;const t=collection(firebaseDb,firebaseCollectionEnum.chats,this.conversation_id,"messages");try{let e={message:this.message,senderID:this.user_uuid,timestamp:Timestamp.now(),serverTimestamp:serverTimestamp(),fileUrl:this.file_url,fileType:this.file_type,photo:this.from_data.photo,senderID:this.from_data.client_uuid,sender:this.from_data.first_name};await addDoc(t,e);this.loading=false;this.documentLastUpdate(this.conversation_id);this.resetChat();this.$emit("afterAddmessage")}catch(e){console.error("Error adding message to the conversation:",e);quasarComponents.notify("red-5",e,"error_outline")}},async documentLastUpdate(e){try{const t=doc(firebaseDb,firebaseCollectionEnum.chats,e);await updateDoc(t,{lastUpdated:serverTimestamp()})}catch(e){quasarComponents.notify("red-5",e,"error_outline")}},resetChat(){this.message="";this.file_url="";this.file_type="";this.files={};this.$refs.uploader.reset()},pickFiles(){this.$refs.uploader.pickFiles()},onRejectedFiles(e){quasarComponents.notify("red-5","Invalid file type","error_outline")},afterAddedFiles(e){Object.entries(e).forEach(([e,t])=>{this.files[t.name]={name:t.name}})},afterRemoveFiles(e){Object.entries(e).forEach(([e,t])=>{delete this.files[t.name]})},onUploadingFiles(e){this.upload_loading=true},afterUploaded(a){if(a.xhr.status==200){let e=JSON.parse(a.xhr.response);let t=e.code||false;let s=e.details||[];let i=e.msg||"";if(t==1){this.file_url=s.file_url;this.file_type=s.file_type;this.saveChatMessage()}else{quasarComponents.notify("red-5",i,"error_outline");this.$refs.uploader.reset()}}else{quasarComponents.notify("red-5","Error uploading files","error_outline");this.$refs.uploader.reset()}},afterFinishUpload(){this.upload_loading=false},showEmoji(){document.querySelector("emoji-picker").addEventListener("emoji-click",e=>{insertText(document.querySelector("textarea"),e.detail.unicode)})},async UpdateWhoistyping(e){try{const t=doc(firebaseDb,firebaseCollectionEnum.chats,this.conversation_id);await updateDoc(t,{[`isTyping.${this.user_uuid}`]:e})}catch(e){console.error("Error updating typing status:",e)}},async startUpload(e,t,s){this.is_recording=false;this.audioPath=e;this.audioBase64=t;this.mimeType=s;try{if(!this.audioBase64){console.error("No audio file to upload");return}this.upload_audio_loading=true;const i={audioBase64:this.audioBase64,fileName:`recording_${Date.now()}.webm`};const a=await axios.post(`${ajaxurl}/uploadaudio`,i,{headers:{"Content-Type":"application/json"}});console.log("response",a);this.upload_audio_loading=false;this.upload_response=a.data;if(a.data.code==1){this.saveChatAudio()}else{quasarComponents.notify("red-5",a.data.msg,"error_outline")}}catch(e){this.upload_response="Failed to upload audio =>"+e.message}},async saveChatAudio(){console.log("saveChatAudio");try{this.loading=true;const t=collection(firebaseDb,firebaseCollectionEnum.chats,this.conversation_id,"messages");let e={messageType:"audio",message:this.message,senderID:this.user_uuid,timestamp:Timestamp.now(),serverTimestamp:serverTimestamp(),fileUrl:this.upload_response.details.file_url,fileType:this.mimeType,photo:this.from_data.photo,senderID:this.from_data.client_uuid,sender:this.from_data.first_name};await addDoc(t,e);this.loading=false;this.documentLastUpdate(this.conversation_id);this.resetChat();this.$emit("afterAddmessage")}catch(e){console.error("Error adding message to the conversation:",e)}}},template:`     
  <div v-if="hasConversation" class="full-width border-grey q-pa-sm radius10">
    
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
  `};const componentsSearchChat={props:["api","label","language","search_type"],data(){return{search:"",is_search:false,awaitingSearch:false}},computed:{hasSearch(){if(!empty(this.search)){return true}return false}},watch:{awaitingSearch(e,t){this.$emit("onSearchloading",e)},is_search(e,t){this.$emit("onSearchchat",e)},search(e,t){this.$emit("setSearchtext",e);if(!this.awaitingSearch){if(empty(e)){return false}setTimeout(()=>{axios({method:"post",url:this.api+"/searchChats?language="+this.language,data:{search:this.search,search_type:this.search_type}}).then(e=>{if(e.data.code==1){this.$emit("onSearchresults",e.data.details)}else{this.$emit("onSearchresults",[])}}).catch(e=>{}).then(e=>{this.awaitingSearch=false})},1e3);this.awaitingSearch=true}}},methods:{closeSearch(){this.is_search=false;this.search=""}},template:`       
    <q-input color="primary" outlined v-model="search" :label="label.search_chat" class="q-mb-md"
    @click="is_search=true"    
    >            
      <template v-slot:prepend>              
        <q-btn v-if="is_search" @click="closeSearch" flat round color="primary" icon="keyboard_backspace" ></q-btn>
      </template>
      <template v-slot:append>
        <q-icon v-if="!is_search" name="search" size="md" ></q-icon>
        <q-btn v-if="hasSearch" @click="search=''" flat round color="primary" icon="highlight_off" ></q-btn>
      </template>
    </q-input>
  `};const deleteMessagesInConversation=async e=>{try{const t=collection(firebaseDb,firebaseCollectionEnum.chats,e,"messages");const s=await getDocs(t);s.forEach(async e=>{await deleteDoc(e.ref)});console.log("All messages in the conversation deleted successfully.")}catch(e){console.error("Error deleting messages in conversation:",e)}};const app_chat=Vue.createApp({components:{"components-participants":componentsParticipants,"components-messages":componentsMessages,"components-chat":componentsChat,"components-search-chat":componentsSearchChat},data(){return{snap_shot:undefined,data:[],drawer:false,message:"",conversation_id:"",user_data:[],user_typing_data:[],chatting_with_uuid:"",file:null,image:null,show_uploader:false,search_chat:false,search_loading:false,search_data:[],search_text:"",chatting_to:null,from_data:null,to_info:null}},created(){if(typeof from_data!=="undefined"&&from_data!==null){this.from_data=JSON.parse(from_data)}if(typeof order_uuid!=="undefined"&&order_uuid!==null){if(!empty(order_uuid)){this.createChatOrder()}}},computed:{hasConversation(){if(!empty(this.conversation_id)){return true}return false},hasMessage(){if(!empty(this.message)){return true}return false},hasSearch(){if(!empty(this.search_text)){return true}return false},hasSearchData(){if(Object.keys(this.search_data).length>0){return true}return false},getSearchData(){return this.search_data}},methods:{setUserdata(e){this.user_data=e},setWhoistyping(e){this.user_typing_data=e},afterClickconversation(e){this.conversation_id=e},setChattingwith(e){this.chatting_to=e;this.scrollTobottom()},afterAddmessage(){this.scrollTobottom();this.notifyUser()},scrollTobottom(){setTimeout(()=>{if(typeof this.$refs.scroll_ref!=="undefined"&&this.$refs.scroll_ref!==null){let e=parseInt(this.$refs.scroll_ref.getScroll().verticalSize)+100;this.$refs.scroll_ref.setScrollPosition("vertical",e)}},500)},onSearchchat(e){this.search_chat=e},onSearchresults(e){this.search_data=e},onSearchloading(e){this.search_loading=e},setSearchtext(e){this.search_text=e},async chatToUser(e,t){try{const s=collection(firebaseDb,firebaseCollectionEnum.chats);const a=query(s,where("participants","array-contains",e),orderBy("lastUpdated","desc"),limit(1));let i="";const r=await getDocs(a);r.forEach(e=>{let t=e.data();let s=t.participants||null;if(s.includes(main_user_uuid)===true){i=e.id}});this.to_info={client_uuid:t.client_uuid,name:t.first_name+" "+t.last_name,first_name:t.first_name,last_name:t.last_name,photo:t.photo_url,user_type:"merchant"};console.log("main_user_uuid=>"+main_user_uuid);console.log("chatToUser=>"+e);console.log("current_doc_id=>"+i);console.log("from_data",this.from_data);console.log("to_info",this.to_info);if(!empty(i)){this.loadConversation(i,e)}else{this.createConversation(e)}}catch(e){quasarComponents.notify("red-5",e,"error_outline")}},async createConversation(t){try{const s=await addDoc(collection(firebaseDb,firebaseCollectionEnum.chats),{lastUpdated:serverTimestamp()});const i=s.id;const a=doc(firebaseDb,firebaseCollectionEnum.chats,i);let e={lastUpdated:serverTimestamp(),dateCreated:serverTimestamp(),participants:[t,main_user_uuid],isTyping:{[`${t}`]:false,[`${main_user_uuid}`]:false},from_info:this.from_data,to_info:this.to_info};console.log("data",e);setDoc(a,e).then(()=>{this.loadConversation(i)}).catch(e=>{quasarComponents.notify("red-5",e,"error_outline")})}catch(e){quasarComponents.notify("red-5",e,"error_outline")}},loadConversation(e){this.$refs.search_chat.closeSearch();this.conversation_id=e;setTimeout(()=>{if(typeof this.$refs.participants!=="undefined"&&this.$refs.participants!==null){this.$refs.participants.document_id=e}},600)},async deleteChat(){try{const t=doc(firebaseDb,firebaseCollectionEnum.chats,this.conversation_id);await deleteDoc(t);let e=this.conversation_id;this.conversation_id="";deleteMessagesInConversation(e)}catch(e){quasarComponents.notify("red-5",e,"error_outline")}},async createChatOrder(){try{let e=null;if(typeof toInfo!=="undefined"&&toInfo!==null){e=JSON.parse(toInfo)}let t={lastUpdated:serverTimestamp(),dateCreated:serverTimestamp(),orderID:order_id,orderUuid:order_uuid,participants:[merchant_uuid,main_user_uuid],isTyping:{[`${merchant_uuid}`]:false,[`${main_user_uuid}`]:false},from_info:this.from_data,to_info:e};await setDoc(doc(firebaseDb,firebaseCollectionEnum.chats,order_uuid),t);console.log("Successful creating docs");this.loadConversation(order_uuid)}catch(e){quasarComponents.notify("red-5",e,"error_outline")}},notifyUser(){let e="to="+this.chatting_to.client_uuid+"&from="+this.from_data.client_uuid;e+="&first_name="+this.from_data.first_name;e+="&last_name="+this.from_data.last_name;e+="&conversation_id="+this.conversation_id;e+="&avatar="+this.from_data.avatar;axios.get(chat_api+"/notifyChatUser?"+e).then(e=>{if(e.data.code==1){}else{}}).catch(e=>{console.error("Error:",e)}).then(e=>{})}}});app_chat.use(Quasar,{config:{notify:{},loadingBar:{skipHijack:true},loading:{}}});app_chat.mount("#app-chat");