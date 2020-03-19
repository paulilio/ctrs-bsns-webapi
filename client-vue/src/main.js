import Vue from "vue";
import VuePageTitle from "vue-page-title";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import NProgress from "vue-nprogress";
//  import { VueCsvImport } from 'vue-csv-import'
import FirebaseAuthService from "./services/firebase";
import i18n from "./plugins/i18n";
import "./registerServiceWorker";
import "./global.scss";

import {
  Avatar,
  TreeSelect,
  Rate,
  Breadcrumb,
  InputNumber,
  Steps,
  Message,
  Upload,
  Button,
  Layout,
  Table,
  Icon,
  Progress,
  Radio,
  Dropdown,
  Menu,
  Carousel,
  Input,
  Calendar,
  Badge,
  Slider,
  Form,
  Tooltip,
  Select,
  Switch,
  Tag,
  Affix,
  Spin,
  Alert,
  Checkbox,
  Tabs,
  Pagination,
  notification,
  Drawer,
  message,
  DatePicker,
} from "ant-design-vue";

Vue.use(Avatar);
Vue.use(Button);
Vue.use(Rate);
Vue.use(TreeSelect);
Vue.use(Breadcrumb);
Vue.use(Layout);
Vue.use(Table);
Vue.use(Icon);
Vue.use(Progress);
Vue.use(Radio);
Vue.use(Dropdown);
Vue.use(Menu);
Vue.use(Carousel);
Vue.use(Input);
Vue.use(Calendar);
Vue.use(Badge);
Vue.use(Slider);
Vue.use(Form);
Vue.use(Tooltip);
Vue.use(Select);
Vue.use(Tag);
Vue.use(Affix);
Vue.use(Spin);
Vue.use(Alert);
Vue.use(Checkbox);
Vue.use(Tabs);
Vue.use(Pagination);
Vue.use(Upload);
Vue.use(Message);
Vue.use(Steps);
Vue.use(InputNumber);
Vue.use(Drawer);
Vue.use(Switch);
Vue.use(notification);
Vue.use(DatePicker);

Vue.prototype.$notification = notification;
Vue.prototype.$message = message;

Vue.use(NProgress);
Vue.use(FirebaseAuthService);
Vue.use(VuePageTitle, {
  prefix: "Control Business 1.0 | ",
  router
});

// Vue.component("VueCsvImport", VueCsvImport );

Vue.config.productionTip = false;
const nprogress = new NProgress({ parent: "body" });

new Vue({
  router,
  store,
  nprogress,
  i18n,
  // VueCsvImport,
  render: h => h(App)
}).$mount("#app");
