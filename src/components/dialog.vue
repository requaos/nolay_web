<template>
    <v-container fluid>
          <v-textarea
            v-model="message"
            outlined
            name="input-7-4"
            label="Message"
            value=""
          ></v-textarea>
          <v-row :justify="'end'"
          >
              <v-col
              md="12"
              >
                  <v-form>
    <v-container>
      <v-row
       style="margin-top: -40px">
        <v-col cols="12" md="8"
        offset-md="2"
        > 
          <v-text-field
            v-model="class_id_or_price"
            :rules="[rules.required, rules.class_or_price]"
            outlined
            dense
            label="MibaoClassID or HecoAddress"
            type="text"
          >
            <template v-slot:append>
              <v-fade-transition leave-absolute>
                <v-progress-circular
                  v-if="loading"
                  size="24"
                  color="info"
                  indeterminate
                ></v-progress-circular>
              </v-fade-transition>
            </template>
          </v-text-field>
        </v-col>
        <v-col cols="12" md="1"
        >
            <v-menu offset-y
             :disabled="notEthAddress"
            >
                <template v-slot:activator="{ on, attrs }">
                    <v-btn
                    dark
                    :disabled="isSellDisable"
                    v-bind="attrs"
                    v-on="on"
                    style="margin-left: -8px; margin-top:3px"
                    @click="sendRequest"
                    >
                    Sell
                    </v-btn>
                </template>
                <v-list>
                    <img :src="qr_code"
                      style="border-radius: 8px;"
                      width="100" height="100"
                    >
                </v-list>
            </v-menu>
        </v-col>
      </v-row>
    </v-container>
  </v-form>
              </v-col>
          </v-row>
    </v-container>
</template>

<script>
import axios from 'axios'
let CryptoJS = require("crypto-js")

export default {
  name: 'Dialog',
  components: {
  },
  data: () => ({
      message: "请输入您要出售的知识或信息...\n并在下框输入解锁该知识所需的 Mibao Class ID \n或者 输入您的HecoChain钱包地址,我们将为你铸造HRC721代币\n",
      loading: false,
      order_id: '',
      qr_code: '',
      class_id_or_price: "",
      unenc_message: "",
      paid: false,
      order_done: false,
      rules: {
        required: value => !!value || 'Required.',
        counter: value => value.length <= 36 || 'Max 36 characters',
        class_or_price: value => {
          const pattern_eth = /^0x[a-fA-F0-9]{40}$/
          const pattern_class = /[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}/
          var is_class_id = pattern_class.test(value)
          var is_price = pattern_eth.test(value)
          var ret = is_class_id || is_price
          return ret || 'Invalid Mibao Class id.'
        }
      }
    }),

    methods: {
        isClassId () {
          const pattern_class = /[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}/
          var is_class_id = pattern_class.test(this.class_id_or_price)
          return is_class_id
        },
        isEthAddress () {
          const pattern_eth = /^0x[a-fA-F0-9]{40}$/
          var is_class_id = pattern_eth.test(this.class_id_or_price)
          return is_class_id
        },
        sendRequest: function() {
            var that = this;
            
            // if classid 
            if(this.isClassId()){
                //   发送bind请求 
                that.loading = true;
                axios.get('https://leepanda.top:5000/new_bind_order/' + this.class_id_or_price)
                    .then(function (response) {
                        // 用返回结果 加密 unenc_message
                        console.log(response);
                        that.loading = false
                        console.log(response);
                        if(response.data.status){
                            const iv = '1234567887654321'
                            var key = response.data.priv_key
                            var message = CryptoJS.AES.encrypt(that.message, CryptoJS.enc.Utf8.parse(key), {
                                iv: CryptoJS.enc.Utf8.parse(iv),
                                mode: CryptoJS.mode.CBC,
                                padding: CryptoJS.pad.Pkcs7
                            }).toString()
                            const BASE_LABEL = '<script src="https://unpkg.com/nolayreading@0.1.0/dist/nft-card.min.js"></scrip' + 't>'
                            that.message = BASE_LABEL + '<nolay-card tokenid="' + that.class_id_or_price + '" enc_message="' + message + '"></nolay-card>'
                        }else{
                            that.message = response.data.reason
                        }
                    })
                    .catch(function (error) {
                        console.log(error);
                        return false
                    });
                return true;
            }else if(this.isEthAddress()){
                //   发送mint请求 
                axios.get('https://leepanda.top:5000/new_create_order/' + this.class_id_or_price)
                    .then(function (response) {
                        // 用返回结果 加密 unenc_message
                        console.log(response)
                        that.loading = false
                        that.unenc_message = that.message
                        that.message = "请支付1元手续费..."
                        if(response.data.status){
                            that.qr_code = response.data.qr_code
                            console.log(that.qr_code)
                            that.order_id = response.data.order_uuid
                            
                            let  timer = setInterval(() => {
                                that.isOrderFinished(timer)
                            }, 1000)

                        }else{
                            that.message = response.data.reason
                        }
                    })
                    .catch(function (error) {
                        console.log(error);
                        return false
                    });
                return true;
            }
            return false;
        },

        isOrderFinished (timer) {
          var that = this
          setTimeout(()=>{
          // 这里ajax 请求的代码片段和判断是否停止定时器
            axios.get('https://leepanda.top:5000/query_order_status/' + that.order_id)
                    .then(function (response) {
                        if(response.data.status){
                            that.loading = true;
                            that.paid = true
                            that.message = "付款成功，正在处理中...链上数据存储将大约消耗30秒左右..."
                        }

                        if(response.data.priv_key != ""){

                            that.loading = false;
                            that.order_done = true;
                            // TODO: 加入 加密要素
                            clearInterval(timer)

                            const iv = '1234567887654321'
                            var key = response.data.priv_key
                            var message = CryptoJS.AES.encrypt(that.unenc_message, CryptoJS.enc.Utf8.parse(key), {
                                iv: CryptoJS.enc.Utf8.parse(iv),
                                mode: CryptoJS.mode.CBC,
                                padding: CryptoJS.pad.Pkcs7
                            }).toString()
                            const BASE_LABEL = '<script src="https://unpkg.com/nolayreading@0.1.0/dist/nft-card.min.js"></scrip' + 't>'
                            that.message = BASE_LABEL + '<nolay-card tokenid="' + that.class_id_or_price + '" enc_message="' + message + '"></nolay-card>'
                        }
                    });
          }, 0)
        },
    },

    computed: {
        isSellDisable () {
            if(this.order_done){
                return true;
            }
          const pattern_eth = /^0x[a-fA-F0-9]{40}$/
          const pattern_class = /[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}/
          var is_class_id = pattern_class.test(this.class_id_or_price)
          var is_price = pattern_eth.test(this.class_id_or_price)
          return !is_class_id && !is_price
        },

        notEthAddress () {
          if(this.paid){
              return true
          }
          const pattern_eth = /^0x[a-fA-F0-9]{40}$/
          var is_class_id = pattern_eth.test(this.class_id_or_price)
          return !is_class_id
        },
    }
}
</script>




    