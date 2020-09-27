import qs from 'qs';
import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { Field, reduxForm, blur } from 'redux-form';
import CheckBox from '../../../components/control/CheckBox';
import Table from '../../../components/Table';
import * as Contants from '../../../constants/common';
import Button from '../../../components/control/Button';
import MessageBanner from '../../../components/MessageBanner';
import { initDailyListParams, setDailyListParams } from '../../../modules/reserve/consultModule';
import { updateMntCapacityRequest } from '../../../modules/preference/scheduleModule';

const formName = 'MntCapacity';

const SearchedKeyword = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const SundayTd = styled.span`
  color: red;
`;

const SaturdayTd = styled.span`
  color: #006699;
`;
const SetSelect = (props) => {
  const params = props.input || props;
  const { items } = props;
  const { onChange, value } = params;
  const select = [];
  const option = [];
  for (let j = 0; j < items.length; j += 1) {
    option.push(<option key={items[j].value} value={items[j].value} >{items[j].name}</option >);
  }
  select.push(<select onChange={onChange} value={value} style={{ height: 23 }}>{option}</select>);
  return select;
};

let strEditDay;
let strEndDay;
const CalendarTd = (condition) => {
  const { year, month, handleDailyListClick } = condition;
  // 休診日設定ドロップダウンリスト
  const items = [{ value: Contants.HOLIDAY_NON, name: '　' }, { value: Contants.HOLIDAY_CLS, name: '休診日' }, { value: Contants.HOLIDAY_HOL, name: '祝日' }];
  const td = [];
  for (let j = 1; j <= 7; j += 1) {
    strEditDay += 1;
    const resTd = [];
    if (strEditDay >= 1 && strEditDay <= strEndDay) {
      const selName = moment(`${year}/${month}/${strEditDay}`).format('YYYYMMDD');
      const dailyListDate = moment(`${year}/${month}/${strEditDay}`).format('YYYY/M/D');
      const aContent = <strong key={`strong${strEditDay.toString()}`}>{strEditDay}</strong>;
      if (j === 1) {
        resTd.push(<a key={`a${strEditDay.toString()}`} role="presentation" onClick={() => handleDailyListClick(dailyListDate)} style={{ textDecoration: 'none', color: 'red' }}>{aContent}</a>);
      } else if (j === 7) {
        resTd.push(<a key={`a${strEditDay.toString()}`} role="presentation" onClick={() => handleDailyListClick(dailyListDate)} style={{ textDecoration: 'none', color: '#006699' }}>{aContent}</a>);
      } else {
        resTd.push(<a key={`a${strEditDay.toString()}`} role="presentation" onClick={() => handleDailyListClick(dailyListDate)} style={{ textDecoration: 'none', color: '#666' }}>{aContent}</a>);
      }
      resTd.push(<div><Field name={`day${selName}`} component={SetSelect} items={items} key={`day${selName}`} /></div>);
    }
    td.push(<td style={{ width: 50, textAlign: 'center', valign: 'top', height: 50 }} key={`td${strEditDay}`}>{resTd}</td>);
  }
  return td;
};

const CalendarTable = ({ year, month, handleDailyListClick }) => {
  const resTr = [];
  // スタート日（先頭が何曜日かを取得）
  strEditDay = 0 - moment(`${year}/${month}/1`).day();
  // 月末日
  strEndDay = moment(`${year}-${month}`, 'YYYY-MM').daysInMonth();
  for (let i = 1; i <= 6; i += 1) {
    resTr.push(<tr style={{ textAlign: 'right' }} key={`tr${i.toString()}`}>{CalendarTd({ year, month, handleDailyListClick })}</tr>);
    if (strEditDay >= strEndDay) {
      return resTr;
    }
  }
  return resTr;
};

const SetMntCapacity = ({ checkFlg, year, month, ischecked, setValue }) => {
  for (let i = 1; i <= strEndDay; i += 1) {
    // 何曜日かを取得
    const editDay = moment(`${year}/${month}/${i}`).day();
    if (editDay === checkFlg) {
      const fieldName = moment(`${year}/${month}/${i}`).format('YYYYMMDD');
      if (ischecked === null) {
        setValue(`day${fieldName}`, Contants.HOLIDAY_NON);
      } else {
        setValue(`day${fieldName}`, Contants.HOLIDAY_CLS);
      }
    }
  }
};

class MntCapacityBody extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // 日クリック時の処理
  handleDailyListClick = (strDate) => {
    const { history, setNewParams } = this.props;
    setNewParams({ strDate });
    history.push({
      pathname: '/reserve/frontdoor/dailylist',
      search: qs.stringify({ strDate }),
    });
  }

  // 保存
  handleSubmit(values) {
    const { onSubmit, year, month } = this.props;
    onSubmit(values, year, month);
  }

  render() {
    const { message, year, month, handleSubmit, setValue } = this.props;
    return (
      <div>
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <MessageBanner messages={message} />
          <div style={{ marginBottom: 10, marginTop: 10 }}>
            <span><SearchedKeyword>{`${year}年${month}月度  病院スケジュール`}</SearchedKeyword>情報を表示しています。 </span>
          </div>
          <div style={{ width: '30%' }}>
            <Table striped hover>
              <thead>
                <tr>
                  <th colSpan="7" ><strong>{`${year}年${month}月度  病院スケジュール`}</strong></th>
                </tr>
                <tr style={{ backgroundColor: '#eeeeee' }}>
                  <th style={{ textAlign: 'right' }}><SundayTd>日</SundayTd></th>
                  <th style={{ textAlign: 'right' }}>月</th>
                  <th style={{ textAlign: 'right' }}>火</th>
                  <th style={{ textAlign: 'right' }}>水</th>
                  <th style={{ textAlign: 'right' }}>木</th>
                  <th style={{ textAlign: 'right' }}>金</th>
                  <th style={{ textAlign: 'right' }}><SaturdayTd>土</SaturdayTd></th>
                </tr>
              </thead>
              <tbody>
                <CalendarTable year={year} month={month} handleDailyListClick={this.handleDailyListClick} />
              </tbody>
            </Table>
          </div>
          <div style={{ marginTop: 10 }}>
            <div>
              <Field component={CheckBox} name="sunday" checkedValue={0} onChange={(event, ischecked) => SetMntCapacity({ checkFlg: 0, year, month, setValue, ischecked })} label="日曜日は全て休診日" />
            </div>
            <div>
              <Field component={CheckBox} name="saturday" checkedValue={6} onChange={(event, ischecked) => SetMntCapacity({ checkFlg: 6, year, month, setValue, ischecked })} label="土曜日は全て休診日" />
            </div>
          </div>
          <div style={{ marginTop: 10 }}>
            <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />
          </div>
        </form>
      </div>
    );
  }
}

const MntCapacityForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(MntCapacityBody);

// propTypesの定義
MntCapacityBody.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  year: PropTypes.string.isRequired,
  month: PropTypes.string.isRequired,
  setNewParams: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  initialValues: state.app.preference.schedule.mntCapacity.calendarItem,
  year: state.app.preference.schedule.mntCapacity.year,
  month: state.app.preference.schedule.mntCapacity.month,
  message: state.app.preference.schedule.mntCapacity.message,
});

const mapDispatchToProps = (dispatch) => ({
  onSubmit: (value, year, month) => {
    const fromDate = moment(`${year}/${month}/1`).format('YYYY/MM/DD');
    const toDate = moment(`${year}/${month}/${strEndDay}`).format('YYYY/MM/DD');

    const calendarItem = [];
    for (let i = 1; i <= strEndDay; i += 1) {
      const fieldName = moment(`${year}/${month}/${i}`).format('YYYYMMDD');
      let setValue = value[`day${fieldName}`];
      if (setValue === undefined) {
        setValue = 0;
      } else {
        setValue = Number(value[`day${fieldName}`]);
      }
      calendarItem.push(setValue);
    }

    dispatch(updateMntCapacityRequest({ arrHoliday: calendarItem, warnings: [], strDate: fromDate, endDate: toDate }));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
  setNewParams: (params) => {
    dispatch(initDailyListParams());
    dispatch(setDailyListParams({ newParams: params }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(MntCapacityForm);
