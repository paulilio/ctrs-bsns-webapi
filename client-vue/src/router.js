import Vue from "vue";
import Router from "vue-router";
import LoginLayout from "@/layouts/Login";
import MainLayout from "@/layouts/Main";
import store from "@/store";

Vue.use(Router);

const router = new Router({
  base: process.env.BASE_URL,
  routes: [
    {
      path: "/",
      redirect: "dashboard/principal",
      component: MainLayout,
      meta: {
        authRequired: true,
        hidden: true
      },
      children: [
        // Dashboards
        {
          path: "/dashboard/principal",
          meta: {
            title: "Principal"
          },
          component: () => import("./views/dashboard/principal")
        },
        // Situacaoatual
        {
          path: "/situacaoatual/importacaodados",
          meta: {
            title: "Importação de Dados"
          },
          component: () => import("./views/situacaoatual/importacaodados")
        },
        // Faturamento
        {
          path: "/situacaoatual/faturamento",
          meta: {
            title: "Faturamento"
          },
          component: () => import("./views/situacaoatual/faturamento")
        },
        // Contas a Receber
        {
          path: "/situacaoatual/contasReceber",
          meta: {
            title: "contas a Receber"
          },
          component: () => import("./views/situacaoatual/contasReceber")
        },
        // Contas a Pagar
        {
          path: "/situacaoatual/contasPagar",
          meta: {
            title: "contas a Pagar"
          },
          component: () => import("./views/situacaoatual/contasPagar")
        },
        // Inadimplentes
        {
          path: "/situacaoatual/inadimplente",
          meta: {
            title: "Inadimplentes"
          },
          component: () => import("./views/situacaoatual/inadimplente")
        },
        // Caixa e Banco
        {
          path: "/situacaoatual/banco",
          meta: {
            title: "Caixa e Banco"
          },
          component: () => import("./views/situacaoatual/banco")
        },
        // Estoque
        {
          path: "/situacaoatual/estoque",
          meta: {
            title: "Estoque"
          },
          component: () => import("./views/situacaoatual/estoque")
        },


        // Relatórios - Confronto de Dados
        {
          path: "/relatorios/estoque",
          meta: {
            title: "Controle de Estoque"
          },
          component: () => import("./views/relatorios/estoque")
        },
        // Relatórios - Confronto de Dados
        {
          path: "/relatorios/confronto",
          meta: {
            title: "Confronto de Dados"
          },
          component: () => import("./views/relatorios/confronto")
        },


        // Técnico-Wizard
        {
          path: "/wizard",
          meta: {
            title: "Exemplo Wizard"
          },
          component: () => import("./views/wizard")
        },

        // 404
        {
          path: "/404",
          meta: {
            title: "404"
          },
          component: () => import("./views/404")
        }
      ]
    },

    // System Pages
    {
      path: "/user",
      component: LoginLayout,
      redirect: "/user/login",
      children: [
        {
          path: "/user/login",
          meta: {
            title: "Login"
          },
          component: () => import("./views/user/login")
        },
        {
          path: "/user/forgot",
          meta: {
            title: "Forgot Password"
          },
          component: () => import("./views/user/forgot")
        }
      ]
    },

    // Redirect to 404
    {
      path: "*",
      redirect: "/404",
      hidden: true
    }
  ]
});

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.authRequired)) {
    if (!store.state.user.user) {
      next({
        path: "/user/login",
        query: { redirect: to.fullPath }
      });
    } else {
      next();
    }
  } else {
    next();
  }
});

export default router;
