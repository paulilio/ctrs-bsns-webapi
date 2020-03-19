<template>
  <div>

<div :class="$style.wrapper">
  <div :class="$style.searchHeader">
    

    <div class="row">
      <div class="col-xl-9">

          <a-dropdown-button @click="handleButtonClick" :class="$style.searchDropdown">
          Unidade
          <a-menu slot="overlay" @click="handleMenuClick">
            <a-menu-item key="1"><a-icon type="user" />1st menu item</a-menu-item>
            <a-menu-item key="2"><a-icon type="user" />2nd menu item</a-menu-item>
            <a-menu-item key="3"><a-icon type="user" />3rd item</a-menu-item>
          </a-menu>
        </a-dropdown-button>

          <a-dropdown-button @click="handleButtonClick" :class="$style.searchDropdown">
          Centro de Custo
          <a-menu slot="overlay" @click="handleMenuClick">
            <a-menu-item key="1"><a-icon type="user" />1st menu item</a-menu-item>
            <a-menu-item key="2"><a-icon type="user" />2nd menu item</a-menu-item>
            <a-menu-item key="3"><a-icon type="user" />3rd item</a-menu-item>
          </a-menu>
        </a-dropdown-button>

      </div>

      <div class="col-xl-3">
        <a
          href="javascript: void(0)"
          :class="[$style.headerLink, 'btn btn-sm btn-primary']"
        >Create Account</a>
        <a href="javascript: void(0)" :class="[$style.headerLink, 'ml-4']">Support</a>
        <a href="javascript: void(0)" :class="[$style.headerLink, 'ml-4']">
          Sign In
          <i class="icmn icmn-arrow-right2"/>
        </a>
      </div>

    </div>
  </div>
</div>

    <div class="utils__title mb-3">
      <strong class="text-uppercase font-size-8"></strong>
    </div>
    <div class="row">
      <div class="col-xl-4" v-for="(chartCard, index) in chartCardData" :key="index">
        <cui-chart-card
          :title="chartCard.title"
          :amount="chartCard.amount"
          :chartData="chartCard.chartData"
        />
      </div>
    </div>

    <div class="row">
      <div class="col-lg-12">
        <div class="card">

          <div class="card-header">
            <div class="utils__title">
              <strong>Recently Referrals</strong>
            </div>
          </div>

          <div class="card-body">
            <!--content-->
          </div>
        </div>
      </div>
    </div>    
  </div>
</template>

<script>
import data from './data.json'
import CuiChartCard from '@/components/CleanUIComponents/ChartCard'
import CuiPaymentCard from '@/components/CleanUIComponents/PaymentCard'
import CuiPaymentAccount from '@/components/CleanUIComponents/PaymentAccount'
import CuiPaymentTransaction from '@/components/CleanUIComponents/PymentTransaction'

const referalsColumns = [
  {
    title: 'Name',
    dataIndex: 'name',
    key: 'name',
  },
  {
    title: 'Position',
    dataIndex: 'position',
    key: 'position',
  },
  {
    title: 'Age',
    dataIndex: 'age',
    key: 'age',
    sorter: (a, b) => a.age - b.age,
  },
  {
    title: 'Office',
    dataIndex: 'office',
    key: 'office',
  },
  {
    title: 'Date',
    dataIndex: 'date',
    key: 'date',
  },
  {
    title: 'Salary',
    dataIndex: 'salary',
    key: 'salary',
    sorter: (a, b) => a.salary - b.salary,
  },
]

export default {
  components: {
    CuiPaymentTransaction,
    CuiChartCard,
    CuiPaymentCard,
    CuiPaymentAccount,
  },
  data() {
    return {
      chartCardData: data.chartCardData,
      paymentAccountsData: data.paymentAccountsData,
      paymentCardsData: data.paymentCardsData,
      paymentTransactionsData: data.paymentTransactionsData,
      progressCardsData: data.progressCardsData,
      referalsData: data.referalsData,
      referalsColumns,
    }
  },

}
</script>


<style lang="scss" module>
@import "./style.module.scss";
</style>