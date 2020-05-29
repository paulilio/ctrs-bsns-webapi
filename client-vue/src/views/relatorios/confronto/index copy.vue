<template>
  <div>
    <!-- Estatísticas -->
    <div class="utils__title mb-3">
      <strong class="text-uppercase font-size-16">CONFRONTO DE DADOS</strong>
    </div>

    <!-- Confronto de dados contas a receber -->
    <div class="row">

      <div class="col-lg-12">
        <div class="card card--fullHeight">
          <div class="card-header">
            <div class="utils__title utils__title--flat">
              <strong class="text-uppercase font-size-16">Confronto de Dados Contas a Receber</strong>
            </div>
          </div>
          <div class="card-body">
            <div class="row">
              <div class="col-xl-8">
                <div class="mb-3">
                  <a-table
                    :columns="supportCasesTableColumns"
                    :dataSource="supportCasesTableData"
                    :pagination="false"
                    class="utils__scrollTable"
                    :scroll="{ x: '100%' }"
                  >
                    <span
                      slot="amount"
                      slot-scope="data"
                      :class="[data === 'Negative' ? 'text-danger' : 'text-primary', 'font-weight-bold']"
                    >{{data}}</span>
                  </a-table>
                </div>
              </div>
              <div class="col-xl-4">
                <div
                  class="h-100 d-flex flex-column justify-content-center align-items-center"
                  :class="$style.chartPieExample"
                >
                  <vue-chartist
                    type="Pie"
                    :data="supportCasesPieData"
                    :options="supportCasesPieOptions"
                  />
                  <div class="text-center mt-2">
                    <span class="mr-2 mt-1 d-inline-block">
                      <cui-donut type="success" name="Ready"></cui-donut>
                    </span>
                    <span class="mr-2 mt-1 d-inline-block">
                      <cui-donut type="primary" name="In progress"></cui-donut>
                    </span>
                    <span class="mr-2 mt-1 d-inline-block">
                      <cui-donut type="danger" name="Defected"></cui-donut>
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>






    <div class="row">
      <div class="col-lg-12">
        <div class="card">
          <div class="card-header">
            <div class="row">
              <div class="col-lg-3">
                <cui-info-card form="bordered" icon="home" type="danger"/>
              </div>
              <div class="col-lg-3">
                <cui-info-card form="bordered" icon="key" type="primary"/>
              </div>
              <div class="col-lg-3">
                <cui-info-card form="bordered" icon="play2" type="warning"/>
              </div>
              <div class="col-lg-3">
                <cui-info-card form="bordered" icon="database" type="sucess"/>
              </div>
            </div>
          </div>
          <div class="card-body">
            <a-table
              :columns="tableColumns"
              :dataSource="tableData"
              :pagination="false"
              class="utils__scrollTable"
              :scroll="{ x: '100%' }"
            >
              <div
                slot="filterDropdown"
                slot-scope="{ setSelectedKeys, selectedKeys, confirm, clearFilters, column }"
                class="custom-filter-dropdown"
              >
                <a-input
                  v-ant-ref="c => searchInput = c"
                  :placeholder="`Search ${column.dataIndex}`"
                  :value="selectedKeys[0]"
                  @change="e => setSelectedKeys(e.target.value ? [e.target.value] : [])"
                  @pressEnter="() => handleSearch(selectedKeys, confirm)"
                  style="width: 188px; margin-bottom: 8px; display: block;"
                />
                <a-button
                  type="primary"
                  @click="() => handleSearch(selectedKeys, confirm)"
                  icon="search"
                  size="small"
                  style="width: 90px; margin-right: 8px"
                >Search</a-button>
                <a-button
                  @click="() => handleReset(clearFilters)"
                  size="small"
                  style="width: 90px"
                >Reset</a-button>
              </div>
              <a-icon
                slot="filterIcon"
                slot-scope="filtered"
                type="search"
                :style="{ color: filtered ? '#108ee9' : undefined }"
              />
              <template slot="customRender" slot-scope="text">
                <span v-if="searchText">
                  <template
                    v-for="(fragment, i) in text.toString().split(new RegExp(`(?<=${searchText})|(?=${searchText})`, 'i'))"
                  >
                    <mark
                      v-if="fragment.toLowerCase() === searchText.toLowerCase()"
                      :key="i"
                      class="highlight"
                    >{{fragment}}</mark>
                    <template v-else>{{fragment}}</template>
                  </template>
                </span>
                <template v-else>{{text}}</template>
              </template>
            </a-table>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import VueChartist from 'v-chartist'
import CuiProgressCard from '@/components/CleanUIComponents/ProgressCard'
import CuiShortItemInfo from '@/components/CleanUIComponents/ShortItemInfo'
import CuiDonut from '@/components/CleanUIComponents/Donut'
import ChartistTooltip from 'chartist-plugin-tooltips-updated'
import CuiProfileHeadCard from '@/components/CleanUIComponents/ProfileHeadCard'
import CuiProgressGroup from '@/components/CleanUIComponents/ProgressGroup'
import CuiUserCard from '@/components/CleanUIComponents/UserCard'
import CuiInfoCard from '@/components/CleanUIComponents/InfoCard'
import CuiSliderCard from '@/components/CleanUIComponents/SliderCard'
import CuiChat from '@/components/CleanUIComponents/Chat'


import {
  progressCardsData,
  newUsersData,
  inboundBandwidthData,
  outboundBandwidthData,
  topPhotosData,
  topPhotosGraphData,
  financeStatsData,
  supportCasesTableData,
  supportCasesPieData,
  taskTableData, tableData, rangeSlider, weekChartistData, monthCartistData
} from './data.json'

const boundChartistOptions = {
  showPoint: true,
  showLine: true,
  showArea: true,
  fullWidth: true,
  showLabel: false,
  axisX: {
    showGrid: false,
    showLabel: false,
    offset: 0,
  },
  axisY: {
    showGrid: false,
    showLabel: false,
    offset: 0,
  },
  chartPadding: 0,
  low: 0,
  plugins: [
    ChartistTooltip({
      anchorToPoint: false,
      appendToBody: true,
      seriesName: false,
    }),
  ],
}

const supportCasesPieOptions = {
  donut: true,
  donutWidth: 35,
  showLabel: false,
  fullWidth: true,
  plugins: [
    ChartistTooltip({
      anchorToPoint: false,
      appendToBody: true,
      seriesName: false,
    }),
  ],
}

const supportCasesTableColumns = [
  {
    title: 'Type',
    dataIndex: 'type',
    key: 'type',
  },
  {
    title: 'Amount',
    key: 'amount',
    dataIndex: 'amount',
    scopedSlots: { customRender: 'amount' },
  },
]

const taskTableColumns = [
  {
    title: 'Name',
    dataIndex: 'name',
    key: 'name',
    scopedSlots: { customRender: 'name' },
  },
  {
    title: 'Username',
    dataIndex: 'username',
    key: 'username',
    scopedSlots: { customRender: 'username' },
  },
  {
    title: 'Actions',
    dataIndex: 'actions',
    key: 'actions',
    scopedSlots: { customRender: 'actions' },
  },
]

const tableColumns = [
  {
    title: 'Name',
    dataIndex: 'name',
    key: 'name',
    scopedSlots: {
      filterDropdown: 'filterDropdown',
      filterIcon: 'filterIcon',
      customRender: 'customRender',
    },
    onFilter: (value, record) => record.name.toLowerCase().includes(value.toLowerCase()),
    onFilterDropdownVisibleChange: (visible) => {
      if (visible) {
        setTimeout(() => {
          this.searchInput.focus()
        }, 0)
      }
    },
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

const rowSelection = {
  onChange: (selectedRowKeys, selectedRows) => {
    console.log(`selectedRowKeys: ${selectedRowKeys}`, 'selectedRows: ', selectedRows)
  },
  onSelect: (record, selected, selectedRows) => {
    console.log(record, selected, selectedRows)
  },
  onSelectAll: (selected, selectedRows, changeRows) => {
    console.log(selected, selectedRows, changeRows)
  },
}

const rangeMarks = {
  0: '0',
  10: '10',
  20: '20',
  30: '30',
  40: '40',
  50: '50',
  60: '60',
  70: '70',
  80: '80',
  90: '90',
  100: '100',
}

const weekChartistOptions = {
  fullWidth: true,
  showArea: false,
  chartPadding: {
    right: 30,
    left: 0,
  },
}

const monthChartistOptions = {
  seriesBarDistance: 10,
}

export default {
  components: {
    'vue-chartist': VueChartist,
    CuiProgressCard,
    CuiShortItemInfo,
    CuiDonut,

    CuiProfileHeadCard,
    CuiProgressGroup,
    CuiUserCard,
    CuiInfoCard,
    CuiSliderCard,
    CuiChat,
  },
  data: function () {
    return {
      taskTableColumns,
      taskTableData,
      rowSelection,
      tableData,
      tableColumns,
      searchText: '',
      searchInput: null,
      rangeMarks,
      rangeSlider,
      weekChartistData,
      weekChartistOptions,
      monthCartistData,
      monthChartistOptions,

      progressCardsData,
      newUsersData,
      inboundBandwidthData,
      outboundBandwidthData,
      topPhotosData,
      topPhotosGraphData,
      financeStatsData,
      supportCasesTableData,
      supportCasesPieData,
      boundChartistOptions,
      supportCasesPieOptions,
      supportCasesTableColumns,
    }
  },
  methods: {
    handleSearch(selectedKeys, confirm) {
      confirm()
      this.searchText = selectedKeys[0]
    },

    handleReset(clearFilters) {
      clearFilters()
      this.searchText = ''
    },
    getListData(value) {
      let listData
      switch (value.date()) {
        case 8:
          listData = [
            { type: 'warning', content: 'This is warning event.' },
            { type: 'success', content: 'This is usual event.' },
          ]; break
        case 10:
          listData = [
            { type: 'warning', content: 'This is warning event.' },
            { type: 'success', content: 'This is usual event.' },
            { type: 'error', content: 'This is error event.' },
          ]; break
        case 15:
          listData = [
            { type: 'warning', content: 'This is warning event' },
            { type: 'success', content: 'This is very long usual event。。....' },
            { type: 'error', content: 'This is error event 1.' },
            { type: 'error', content: 'This is error event 2.' },
            { type: 'error', content: 'This is error event 3.' },
            { type: 'error', content: 'This is error event 4.' },
          ]; break
        default:
      }
      return listData || []
    },
    getMonthData(value) {
      if (value.month() === 8) {
        return 1394
      }
    },
  },
}
</script>

<style lang="scss" module>
@import "./style.module.scss";

.custom-filter-dropdown {
  padding: 8px;
  border-radius: 4px;
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.highlight {
  background-color: rgb(255, 192, 105);
  padding: 0px;
}

.events {
  list-style: none;
  margin: 0;
  padding: 0;
}
.events .ant-badge-status {
  overflow: hidden;
  white-space: nowrap;
  width: 100%;
  text-overflow: ellipsis;
  font-size: 12px;
}
.notes-month {
  text-align: center;
  font-size: 28px;
}
.notes-month section {
  font-size: 28px;
}
</style>
