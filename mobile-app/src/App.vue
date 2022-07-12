<template>
<v-app>
  <v-row>
    <v-card>
        <v-navigation-drawer
          permanent
          expand-on-hover
        >
          <v-list>
            <v-list-item class="px-2">
              <v-list-item-avatar>
                <v-img src="./assets/roostercoop-logo.png"></v-img>
              </v-list-item-avatar>
            </v-list-item>

            <v-list-item link>
              <v-list-item-content>
                <v-list-item-title class="text-h6">
                  Crypto Doc Suite
                </v-list-item-title>
                <v-list-item-subtitle>Blockchain Secured Documents</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </v-list>

          <v-divider></v-divider>

          <v-list
            nav
            dense
            v-for="(item, i) in navItems"
            :key="i"
          >
            <v-list-item @click="setMainComponent(item.component)">
              <v-list-item-icon>
                <v-icon>{{ item.icon }}</v-icon>
              </v-list-item-icon>
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-navigation-drawer>
      </v-card>

      <!-- Sizes your content based upon application components -->
      <v-main>
        <!-- Provides the application the proper gutter -->
        <v-container fluid>
          <my-files v-if="mainComponent == 'my-files'"></my-files>
          <starred v-if="mainComponent == 'starred'"></starred>
          <settings v-if="mainComponent == 'settings'"></settings>
          <about v-if="mainComponent == 'about'"></about>
          <shared-with-me v-if="mainComponent == 'shared-with-me'"></shared-with-me>
        </v-container>
      </v-main>
  </v-row>

  <v-footer app>
    <!-- -->
  </v-footer>
</v-app>
</template>

<script>
import MyFiles from './pages/MyFiles.vue';
import Starred from './pages/Starred.vue';
import Settings from './pages/Settings.vue';
import About from './pages/About.vue';
import SharedWithMe from './pages/SharedWithMe.vue';

export default {
  name: 'App',

  components: {
    MyFiles,
    Starred,
    Settings,
    About,
    SharedWithMe
  },

  data: () => ({
    navItems: [
      { title: 'My Files', icon: 'mdi-view-dashboard', component: 'my-files' },
      { title: 'Shared with Me', icon: 'mdi-image', component: 'shared-with-me' },
      { title: 'Starred', icon: 'mdi-star', component: 'starred' },
      { title: 'Settings', icon: 'mdi-cog', component: 'settings' },
      { title: 'About', icon: 'mdi-help-box', component: 'about' },
    ],
    mainComponent: 'my-files',
    metaIcon: 'mdi-account-circle',
  }),
  methods: {
    setMainComponent(component) {
      this.mainComponent = component;
    }
  }
};
</script>
