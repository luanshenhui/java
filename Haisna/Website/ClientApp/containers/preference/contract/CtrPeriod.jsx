import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { reduxForm, getFormValues } from 'redux-form';
import moment from 'moment';
import PageLayout from '../../../layouts/PageLayout';
import Button from '../../../components/control/Button';
import MessageBanner from '../../../components/MessageBanner';
import CtrPeriodBody from './CtrPeriodBody';
import * as Constants from '../../../constants/common';

import { initializePeriod, getCtrMngWithPeriodRequest, updatePeriodRequest } from '../../../modules/preference/contractModule';
import { getCourseHistoryRequest } from '../../../modules/preference/courseModule';

const formName = 'ctrPeriodCopyForm';

class CtrPeriod extends React.Component {
  constructor(props) {
    super(props);

    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleSubmitClick = this.handleSubmitClick.bind(this);
  }

  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  // 戻るボタンクリック時の処理
  handleCancelClick() {
    const { history } = this.props;
    history.goBack();
  }

  // 次へボタン押下時の処理
  handleSubmitClick() {
    const { history, match, onSubmit, formValues } = this.props;
    const { strdate, enddate } = formValues;
    const { opmode, orgcd1, orgcd2, cscd } = match.params;
    const paramStrdate = moment(strdate).format('YYYY-MM-DD');
    const paramEnddate = moment(enddate).format('YYYY-MM-DD');
    const refOrgCd1 = Constants.ORGCD1_PERSON;
    const refOrgCd2 = Constants.ORGCD2_PERSON;
    // web予約の場合は直接契約情報の選択画面に遷移し、それ以外は参照先契約団体の検索画面へ
    if (orgcd1 === Constants.ORGCD1_WEB && orgcd2 === Constants.ORGCD2_WEB) {
      onSubmit(
        match.params,
        { ...formValues, orgcd1, orgcd2, cscd },
        () => history.push(`/contents/preference/contract/${opmode}/${orgcd1}/${orgcd2}/${cscd}/${refOrgCd1}/${refOrgCd2}/${paramStrdate}/${paramEnddate}/refcontracts`),
      );
    } else {
      onSubmit(
        match.params,
        { ...formValues, orgcd1, orgcd2, cscd },
        () => history.push(`/contents/preference/contract/${opmode}/organization/${orgcd1}/${orgcd2}/${cscd}/${paramStrdate}/${paramEnddate}`),
      );
    }
  }

  render() {
    const { message, courseHistoryData, dtmArrDate, match } = this.props;

    return (
      <PageLayout title="契約期間の指定">
        <div>
          <form>
            <div >
              <Button onClick={this.handleCancelClick} value="戻 る" />
              <Button onClick={this.handleSubmitClick} value="次 へ" />
            </div>
            <MessageBanner messages={message} />
            <CtrPeriodBody courseHistoryData={courseHistoryData} dtmArrDate={dtmArrDate} params={match.params} newmode />
          </form>
        </div>
      </PageLayout>
    );
  }
}

const CtrPeriodForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  enableReinitialize: true,
})(CtrPeriod);

// propTypesの定義
CtrPeriod.propTypes = {
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  courseHistoryData: PropTypes.arrayOf(PropTypes.string).isRequired,
  dtmArrDate: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onSubmit: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  formValues: PropTypes.shape(),
};

CtrPeriod.defaultProps = {
  formValues: null,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    message: state.app.preference.contract.ctrPeriod.message,
    ctrPtData: state.app.preference.contract.ctrPeriod.ctrPtData,
    courseHistoryData: state.app.preference.course.courseHistory.courseHistoryData,
    dtmArrDate: state.app.preference.contract.ctrPeriod.dtmArrDate,
    initialValues: {
      strdate: state.app.preference.contract.ctrPeriod.ctrPtData.strdate,
      enddate: state.app.preference.contract.ctrPeriod.ctrPtData.enddate,
    },
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // 画面を初期化
  onLoad: (params) => {
    dispatch(initializePeriod());
    dispatch(getCtrMngWithPeriodRequest({ ...params }));
    dispatch(getCourseHistoryRequest({ ...params }));
  },
  // 次へボタン押下時の処理
  onSubmit: (params, data, redirect) => {
    const actmode = 'browse';
    dispatch(updatePeriodRequest({ redirect, actmode, data }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(CtrPeriodForm);
