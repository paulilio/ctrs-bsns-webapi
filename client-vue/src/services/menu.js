export const getLeftMenuData = [
  {
    title: 'Principal',
    key: 'dashboardAlpha',
    url: '/dashboard/principal',
    icon: 'icmn icmn-home',
  },
  {
    title: 'Situação Atual',
    key: 'situacao',
    icon: 'icmn icmn-stats-bars',
    children: [
      {
        title: 'Importação de Dados',
        key: 'importacaodados',
        url: '/situacaoatual/importacaodados',
      },
      {
        title: 'Faturamento',
        key: 'chartist',
        url: '/charts/chartist',
      },
      {
        title: 'Contas a Receber',
        key: 'chart',
        url: '/charts/chart',
        pro: true,
      },
      {
        title: 'Contas a Pagar',
        key: 'chart',
        url: '/charts/chart',
        pro: true,
      },
      {
        title: 'Inadimplência',
        key: 'peity',
        url: '/charts/peity',
        pro: true,
      }
    ],
  },
  {
    title: 'Relatórios',
    key: 'charts',
    icon: 'icmn icmn-stats-bars',
    children: [
      {
        title: 'Fluxo de Caixa',
        key: 'chartist',
        url: '/charts/chartist',
      },
      {
        title: 'DRE',
        key: 'chart',
        url: '/charts/chart',
        pro: true,
      }
    ],
  },
  {
    divider: true, 
   },
  {
    title: 'Cadastros Básicos',
    key: 'defaultPages',
    icon: 'icmn icmn-file-text',
    children: [
      {
        key: 'loginAlpha',
        title: 'Unidades',
        url: '/pages/login-alpha',
        pro: true,
      },
      {
        key: 'loginBeta',
        title: 'Plano Contas',
        url: '/pages/login-beta',
        pro: true,
      },
      {
        key: 'register',
        title: 'Centro de Receitas/Custo',
        url: '/pages/register',
        pro: true,
      }
    ],
  }
]
export const getTopMenuData = [
  {
    title: 'Dashboard Alpha',
    key: 'dashboardAlpha',
    url: '/dashboard/alpha',
    icon: 'icmn icmn-home',
  },
]
