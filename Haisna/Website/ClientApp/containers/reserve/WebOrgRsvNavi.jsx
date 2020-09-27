import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { getFormValues, reduxForm } from 'redux-form';
import { withRouter } from 'react-router-dom';
import MessageBanner from '../../components/MessageBanner';
import { webOrgRsvMainLoadRequest, registRequest, closeWebOrgRsvMainGuide } from '../../modules/reserve/webOrgRsvModule';
import Button from '../../components/control/Button';
import { openCommentListFlameGuide } from '../../modules/preference/pubNoteModule';
import CommentListFlameGuide from '../../containers/preference/comment/CommentListFlameGuide';

const Wrapper = styled.span`
   color: #ff6600;
`;
const formName = 'WebOrgRsvNavi';

class WebOrgRsvNavi extends React.Component {
  handleShowNext() {
    const { params, onShowNext, webOrgRsvData } = this.props;
    params.div = 'next';
    params.orgcd1 = webOrgRsvData.orgcd1;
    params.orgcd2 = webOrgRsvData.orgcd2;
    onShowNext(params);
  }
  handleRegist(value) {
    const { params, onRegist, frameUsedData, perFormValues, detailFormValues, optFormValues, newctrptcd } = this.props;
    if (value === 1) {
      // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
      // eslint-disable-next-line no-alert,no-restricted-globals
      if (!confirm('この内容でweb予約情報を登録します。よろしいですか？')) {
        return;
      }
    }
    // 住所区分の配列を作成
    const addrdiv = [1, 2, 3];
    const data = {};
    data.upduser = 'HAINS$';
    data.AddrDiv = addrdiv;
    data.romename = null;
    data.nationcd = null;
    Object.assign(data, frameUsedData);
    Object.assign(data, perFormValues);
    Object.assign(data, detailFormValues);
    data.webno = params.webno;
    data.regflg = params.regflg;
    data.ctrptcd = newctrptcd;

    let optcd = '';
    let optbranchno = '';
    if (optFormValues.opt !== undefined) {
      for (let i = 0; i < optFormValues.ctrptoptfromconsult && optFormValues.ctrptoptfromconsult.length; i += 1) {
        if (optFormValues.opt.length !== optFormValues.ctrptoptfromconsult.length
          && optFormValues.ctrptoptfromconsult[i].consults === 1
          && optFormValues.ctrptoptfromconsult[i].hidersv !== null) {
          optcd += `${optFormValues.ctrptoptfromconsult[i].optcd},`;
          optbranchno += `${optFormValues.ctrptoptfromconsult[i].optbranchno},`;
        }
      }
      for (let j = 0; j < optFormValues.opt.length; j += 1) {
        if (optFormValues.opt[j] !== null) {
          optcd += `${optFormValues.opt[j].split(',')[0]},`;
          optbranchno += `${Number(optFormValues.opt[j].split(',')[1])},`;
        }
      }
    }
    data.optcd = optcd.substring(0, optcd.length - 1);
    data.optbranchno = optbranchno.substring(0, optbranchno.length - 1);
    onRegist(data);
  }
  handleShowCommit() {
    const { frameUsedData, onShowGuideNote, newctrptcd } = this.props;
    const params = {};
    params.orgcd1 = frameUsedData.orgcd1;
    params.orgcd2 = frameUsedData.orgcd2;
    params.dispmode = '1';
    params.cmtmode = '1,1,1,1';
    if (frameUsedData.rsvno !== null) {
      params.perid = frameUsedData.perid;
      params.rsvno = frameUsedData.rsvno;
    }
    params.ctrptcd = newctrptcd;
    onShowGuideNote(params);
  }
  render() {
    const { onClose, frameUsedData, message } = this.props;
    return (
      <div style={{ float: 'left', width: '100%' }}>
        {frameUsedData && frameUsedData.regflg !== '2' && (
          <Button onClick={() => (this.handleRegist(0))} value="确定" />
        )}
        {frameUsedData && frameUsedData.webOrgRsvNext && frameUsedData.regflg !== '2' && (
          <Button onClick={() => (this.handleRegist(1))} value="次へ" />
        )}
        {frameUsedData && frameUsedData.webOrgRsvNext && frameUsedData.regflg === '2' && (
          <Button onClick={() => (this.handleShowNext())} value="次へ" />
        )}
        {frameUsedData && (frameUsedData.cancelflg === null || frameUsedData.cancelflg === undefined || frameUsedData.cancelflg === 0) && (
          <Button onClick={() => (this.handleShowCommit())} value="コメント" />
        )}
        <Button onClick={onClose} value="キャンセル" />
        {frameUsedData.regflg === '2' && (
          <Wrapper>編集済み受診者</Wrapper>
        )}
        <CommentListFlameGuide />
        <MessageBanner messages={message} />
      </div>
    );
  }
}

const WebOrgRsvNaviForm = reduxForm({
  form: formName,
})(WebOrgRsvNavi);

WebOrgRsvNavi.propTypes = {
  onClose: PropTypes.func.isRequired,
  onShowGuideNote: PropTypes.func.isRequired,
  perFormValues: PropTypes.shape(),
  detailFormValues: PropTypes.shape(),
  optFormValues: PropTypes.shape(),
  onShowNext: PropTypes.func.isRequired,
  onRegist: PropTypes.func.isRequired,
  webOrgRsvData: PropTypes.shape(),
  params: PropTypes.shape(),
  newctrptcd: PropTypes.number,
  frameUsedData: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
};

WebOrgRsvNavi.defaultProps = {
  perFormValues: null,
  detailFormValues: null,
  optFormValues: null,
  webOrgRsvData: null,
  params: null,
  newctrptcd: null,
};

const mapStateToProps = (state) => {
  const perFormValues = getFormValues('WebOrgRsvPersonalDetailGuide')(state);
  const detailFormValues = getFormValues('WebOrgRsvDetail')(state);
  const optFormValues = getFormValues('webOrgRsvOption')(state);
  return {
    perFormValues,
    detailFormValues,
    optFormValues,
    newctrptcd: state.app.reserve.webOrgRsv.webOrgRsvOptionList.newctrptcd,
    regflg: state.app.reserve.webOrgRsv.webOrgRsvList.regflg,
    params: state.app.reserve.webOrgRsv.webOrgRsvList.params,
    frameUsedData: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData,
    webOrgRsvData: state.app.reserve.webOrgRsv.webOrgRsvList.webOrgRsvData,
    message: state.app.reserve.webOrgRsv.webOrgRsvList.message,
  };
};

const mapDispatchToProps = (dispatch) => ({
  onShowNext(params) {
    dispatch(webOrgRsvMainLoadRequest({ params }));
  },

  onRegist(data) {
    dispatch(registRequest(data));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeWebOrgRsvMainGuide());
  },
  onShowGuideNote: (params) => {
    dispatch(openCommentListFlameGuide({ params }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(WebOrgRsvNaviForm));
