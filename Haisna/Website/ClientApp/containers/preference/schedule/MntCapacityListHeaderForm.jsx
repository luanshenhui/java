import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm, blur, getFormValues } from 'redux-form';
import { connect } from 'react-redux';
import moment from 'moment';

import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';

import ListHeaderFormBase from '../../../components/common/ListHeaderFormBase';
import Button from '../../../components/control/Button';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import CheckBox from '../../../components/control/CheckBox';
import Radio from '../../../components/control/Radio';

import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import { getMntCapacityListRequest, settingDate } from '../../../modules/preference/scheduleModule';

const iconvback = (
  <svg width="12" height="12" viewBox="0 0 1024 1024" fill="#CCCCCC">
    <path d="M250.656 448l522.672 448v-896z" />
  </svg>);
const iconvplay = (
  <svg width="12" height="12" viewBox="0 0 1024 1024" fill="#CCCCCC">
    <path d="M773.328 448l-522.672-448v896z" />
  </svg>);

const MntCapacityListHeader = (props) => {
  const { data, setStartDate, formValues, onSearch } = props;
  return (
    <ListHeaderFormBase {...props} >
      <FieldGroup>
        <FieldSet>
          <span style={{ fontSize: '18px', color: '#006699' }} title="日付ガイドを表示">
            <a
              role="presentation"
              onClick={() => {
                onSearch({ conditions: formValues.conditions, startDate: moment(formValues.startDate).subtract(7, 'days').format('YYYY/MM/DD'), gender: formValues.gender });
                setStartDate(true, formValues.startDate);
              }}
              style={{ cursor: 'pointer' }}
            >
              {iconvback}
            </a>
          </span>
          <FieldItem>受診日 :</FieldItem>
          <Field name="startDate" component={DatePicker} id="strDate" />
          <FieldSet>日から１週間 </FieldSet>
          <span style={{ marginLeft: '30px', fontSize: '18px', color: '#006699' }} title="翌週を表示">
            <a
              role="presentation"
              onClick={() => {
                onSearch({ conditions: formValues.conditions, startDate: moment(formValues.startDate).add(7, 'days').format('YYYY/MM/DD'), gender: formValues.gender });
                setStartDate(false, formValues.startDate);
              }}
              style={{ cursor: 'pointer' }}
            >
              {iconvplay}
            </a>
          </span>
        </FieldSet>
        <FieldSet>
          <FieldItem> コース :</FieldItem>
          <GridList cellHeight="auto" style={{ width: 1000 }} cols={7} >
            {data.map((rec) => (
              <GridListTile key={rec.cscd}>
                <Field component={CheckBox} name={`conditions.${rec.cscd}`} checkedValue="1" label={`${rec.cssname}`} />
              </GridListTile>
            ))}
          </GridList>
        </FieldSet>
        <FieldSet>
          <FieldItem>性別 :</FieldItem>
          <Field component={Radio} name="gender" checkedValue="0" label="全て " />
          <Field component={Radio} name="gender" checkedValue="1" label="男性のみ" />
          <Field component={Radio} name="gender" checkedValue="2" label="女性のみ" />
          <Button type="submit" value="表示" />
        </FieldSet>
      </FieldGroup>
    </ListHeaderFormBase>
  );
};

// propTypesの定義
MntCapacityListHeader.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  setStartDate: PropTypes.func.isRequired,
  startDate: PropTypes.string.isRequired,
  conditions: PropTypes.shape().isRequired,
  onSearch: PropTypes.func.isRequired,
  gender: PropTypes.string.isRequired,
  formValues: PropTypes.shape(),
};

MntCapacityListHeader.defaultProps = {
  formValues: undefined,
};

const MntCapacityListHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'MntCapacityListHeader',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(MntCapacityListHeader);

const mapStateToProps = (state) => {
  const formValues = getFormValues('MntCapacityListHeader')(state);
  return {
    formValues,
    conditions: state.app.preference.schedule.mntCapacityList.conditions,
    data: state.app.preference.schedule.courseList.data,
    gender: state.app.preference.schedule.mntCapacityList.gender,
    startDate: state.app.preference.schedule.mntCapacityList.startDate,
    initialValues: {
      conditions: state.app.preference.schedule.mntCapacityList.conditions,
      startDate: state.app.preference.schedule.mntCapacityList.startDate,
      gender: state.app.preference.schedule.mntCapacityList.gender,
    },
  };
};


// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch, props) => ({
  onSearch: (conditions) => {
    let params = {};
    if (!conditions.startDate) {
      const startDate = props.initialDate;
      params = { ...conditions, startDate };
      dispatch(blur('MntCapacityListHeader', 'startDate', startDate));
    } else {
      params = { ...conditions };
    }
    if (!conditions.gender) {
      const gender = '0';
      params = { ...params, gender };
    }
    dispatch(getMntCapacityListRequest(params));
  },
  setStartDate: (days, startDate) => {
    let date = startDate;
    if (days) {
      date = moment(startDate).subtract(7, 'days').format('YYYY/MM/DD');
    } else {
      date = moment(startDate).add(7, 'days').format('YYYY/MM/DD');
    }
    dispatch(settingDate({ startDate: date }));
  },
  initializeList: () => {
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(MntCapacityListHeaderForm));
