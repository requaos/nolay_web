<template>
  <v-container>
    <v-row
        :justify="'center'"
        style="height: 500px;"
    >
      <v-col
          :key="1"
          :align-self="'start'"
          md="4"
      >

      <nolay-card id="nolay" :tokenid="uuid" :enc_message="enc_message"></nolay-card>

      </v-col>
    </v-row>
  </v-container>
</template>

<script>

export default {
  name: 'Reading',
  components: {
  },
  methods: {
    // get_uuid: function () {
    //   // `this` 指向 vm 实例
    // }
  },
  mounted () {
    const nolay_reading = document.createElement("script")
    nolay_reading.setAttribute("src", "https://unpkg.zhimg.com/nolayreading@latest/dist/nft-card.min.js")
    nolay_reading.async = true
    document.head.appendChild(nolay_reading)

    var unipass_param = this.$route.query.unipass_ret;
    if(unipass_param == null){
      localStorage.clear();
    }

    setTimeout(function(){
      var unipass_param = this.$route.query.unipass_ret;
      if(unipass_param != null && unipass_param.search("sig") != -1 ){
        return
      }
      document.querySelector("#nolay").shadowRoot.querySelector("nolay-card-front").shadowRoot.querySelector("div").click()
    }, 1000);
  },
  computed: {
    // 计算属性的 getter
    enc_message: function () {
      // `this` 指向 vm 实例
      return unescape(this.$route.query.param.split('*')[1])
    },
    uuid: function () {
      // `this` 指向 vm 实例
      return unescape(this.$route.query.param.split('*')[0])
    }
  },
  // created() {
  //   if (document.readyState === 'complete') this.something()
  //   else document.addEventListener('load', () => this.something())
  // }
}
</script>