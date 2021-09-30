<template>
 <v-card
        flat
        color="rgb(255, 0, 0, 0)"
        elevation="0"
        height="50px"
    >
      <v-app-bar color="rgb(255, 0, 0, 0)" elevation="0" dense>
        <!-- 标题 -->
        <v-toolbar-title class="grey--text">
            <span>Nolay</span>
        </v-toolbar-title>
      
        <!-- 在v-spacer上面的标签将会在导航栏左侧 在v-spacer下面的标签将会在导航栏右侧 -->
        <v-spacer></v-spacer>
        <!-- 按钮 -->
        <v-btn outlined class="mx-2" color="grey" @click="onClickDocs">
            <span>Docs</span>
        </v-btn>
        <v-btn outlined class="mx-2" color="grey" @click="onClickGithub">
            <span>Github</span>
        </v-btn>
      </v-app-bar>
    </v-card>
</template>

<script>
export default {
  name: 'Header',
  methods: {
      onClickGithub(){
        window.location.href = "https://github.com/nolaytech"
        return
      },
      onClickDocs(){
        window.location.href = "https://pandatea.life/post/nolayreading-bang-zhu-wen-dang-andshi-yong-zhi-nan/"
        return
      }
  }
}
</script>



