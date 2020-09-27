import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import { withRouter, Link } from 'react-router-dom';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import Label from '../../../components/control/Label';
import DropDown from '../../../components/control/dropdown/DropDown';
import * as Contants from '../../../constants/common';
import Button from '../../../components/control/Button';
import ListHeaderFormBase from '../../../components/common/ListHeaderFormBase';
import { getMntCapacityRequest, initializeMntCapacity, initializeMntCapacityBody } from '../../../modules/preference/scheduleModule';

const formName = 'MntCapacityHeader';

// 起算月選択肢
const ageCalcMonthItem = [...Array(12)].map((v, i) => ({ value: i + 1, name: (i + 1).toString() }));
// 起算日選択肢
const ageCalcDayItem = [{ value: Contants.TIME_FRA_NON, name: '終日' }];
// 予約枠ドロップダウンリスト
const rsvFraItems = [{ value: 'ALL', name: '休診日設定（土・日・祝）' }];

const downItems = () => {
  // 起算年選択肢値の設定
  const yearRange = [];
  // 起算年選択肢
  const ageCalcYearItem = [];
  for (let item = Contants.YEARRANGE_MIN; item <= Contants.YEARRANGE_MAX; item += 1) {
    yearRange.push(item);
  }
  for (let Item = 0; Item <= Contants.YEARRANGE_MAX - Contants.YEARRANGE_MIN; Item += 1) {
    ageCalcYearItem.push({ value: yearRange[Item], name: yearRange[Item].toString() });
  }
  return ageCalcYearItem;
};

const MntCapacityHeader = (props) => (
  <div>
    <ListHeaderFormBase {...props} >
      <FieldGroup itemWidth={120}>
        <FieldSet>
          <FieldItem>受診年月</FieldItem>
          <Field name="year" component={DropDown} items={downItems()} id="year" />
          <Label>年</Label>
          <Field name="month" component={DropDown} items={ageCalcMonthItem} id="month" />
          <Label>月</Label>
          <Field name="timeFra" component={DropDown} items={ageCalcDayItem} id="timeFra" />
          <Link style={{ marginLeft: 20 }} to="/contents/preference/schedule/capacity" role="presentation" >設定状況を見る</Link>
        </FieldSet>
        <FieldSet>
          <FieldItem>予約枠</FieldItem>
          <Field name="rsvFraCd" component={DropDown} items={rsvFraItems} />
          <Button style={{ marginLeft: 30 }} type="submit" value="表示" />
        </FieldSet>
      </FieldGroup>
    </ListHeaderFormBase>
  </div>
);

const MntCapacityHeaderForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(MntCapacityHeader);

// propTypesの定義
MntCapacityHeader.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  onSearch: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  initialValues: {
    year: state.app.preference.schedule.mntCapacityHeadForm.conditions.year,
    month: state.app.preference.schedule.mntCapacityHeadForm.conditions.month,
    timeFra: state.app.preference.schedule.mntCapacityHeadForm.conditions.timeFra,
    rsvFraCd: state.app.preference.schedule.mntCapacityHeadForm.conditions.rsvFraCd,
  },
});

const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    const year = conditions.year ? conditions.year : moment(new Date()).format('YYYY');
    const month = conditions.month ? conditions.month : moment(new Date()).format('M');
    const strDate = `${year}/${month}/1`;
    const daySum = moment(`${year}-${month}`, 'YYYY-MM').daysInMonth();
    const endDate = `${year}/${month}/${daySum.toString()}`;
    dispatch(initializeMntCapacityBody({ year, month }));
    dispatch(getMntCapacityRequest({ params: { strDate, endDate }, year, month }));
  },
  initializeList: () => {
    dispatch(initializeMntCapacity());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(MntCapacityHeaderForm));
