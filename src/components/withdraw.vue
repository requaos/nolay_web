<template>
  <v-container>
      <v-row
       style="margin-top: -40px">
        <v-col cols="12" md="8"
        offset-md="2"
        > 
    <v-menu
      top
      :close-on-click="true"
    >
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          color="primary"
          dark
          v-bind="attrs"
          v-on="on"
        >
          Profit {{this.balance}}
        </v-btn>
      </template>

      <v-list>
        <v-list-item>
          <v-text-field
            v-model="ckb_address"
            :rules="[rules.required, rules.is_ckb_address]"
            outlined
            dense
            label="your CKB address"
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
          <template v-slot:activator="{ on, attrs }">
                    <v-btn
                    dark
                    :disabled="this.disable_withdraw"
                    v-bind="attrs"
                    v-on="on"
                    style="margin-left: -8px; margin-top:3px"
                    @click="sendWithdraw"
                    >
                    Withdraw
                    </v-btn>
                </template>
        </v-list-item>
      </v-list>
    </v-menu>
        </v-col>
      </v-row>
    <v-snackbar
      v-model="snackbar"
    >
      {{ this.snackbar_message }}

      <template v-slot:action="{ attrs }">
        <v-btn
          color="pink"
          text
          v-bind="attrs"
          @click="snackbar = false"
        >
          Close
        </v-btn>
      </template>
    </v-snackbar>
  </v-container>
</template>

<script>
import urlencode from 'urlencode'
import axios from 'axios'
export default {
  name: 'Withdraw',
  data: () => ({
      balance: "0",
      disable_withdraw: false,
      ckb_address: "",

      snackbar_message: "",
      snackbar: false,
    }),
  methods: {
        is_ckb_address () {
          const pattern_class = /[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}/
          var is_class_id = pattern_class.test(this.class_id_or_price)
          return is_class_id
        },
        sendWithdraw: function() {
            // 如果是跳转回来的
            var that = this;
            that.loading = true;
            that.disable_withdraw = true;

            var sig = this.getSigFromUrl()
            if (sig != ''){
                that.balance = "0";
                // 发送提现请求
                var data = {
                    "to_address": this.ckb_address,
                    "sign": sig
                }
                axios.get('https://api.nolay.tech:5000/withdraw_order/' + JSON.stringify(data))
                .then(function (response) {
                    // 查看返回状态，成功则弹框 提示成功
                    // 失败则弹框原因。
                    that.loading = false
                    if(response.data.status){
                        that.snackbar_message = "success";
                        that.snackbar = true;
                    }else{
                        that.snackbar_message = response.data.reason
                        that.snackbar = true;
                    }
                })
                .catch(function (error) {
                    console.log(error);
                    return false
                });
            }
            else{
                // 跳转到unipass签名页面
                var url = `https://unipass.xyz/sign?success_url=${window.location.href}&pubkey=${getPubkey()}&message=${message}`
            }
            
            
            
            

            
            return true;
        },

        getSigFromUrl() { // 这个是登录后的解析函数
            const url = new URL(window.location.href);
            console.log('getDataFromUrl--', url);
            let data = '';
            data = url.searchParams.get('unipass_ret');
            console.log("[-]", data);
            if (data == ''){
                console.log("不是登录callback link")
                return '';
            }

            const unipassStr = urlencode.decode(data, 'utf-8');
            var unipassData = JSON.parse(unipassStr);
            console.log(unipassData);
            try{
            if (unipassData.code === 200) {
                // todo save data
                if (unipassData.data.sig) {
                return unipassData.data.sig;
                }
            }
            }catch{
            return ''
            }
                
            return '';
        }
  }
}
</script>




    