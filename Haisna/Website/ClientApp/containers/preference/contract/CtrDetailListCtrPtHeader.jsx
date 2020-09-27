import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import { withRouter } from 'react-router-dom';
import Button from '../../../components/control/Button';
import MessageBanner from '../../../components/MessageBanner';
import SectionBar from '../../../components/SectionBar';
import LabelCourse from '../../../components/control/label/LabelCourse';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import CtrSplitPeriodGuide from './CtrSplitPeriodGuide';
import CtrStandardGuide from './CtrStandardGuide';
import CtrLimitPriceGuide from './CtrLimitPriceGuide';
import CtrPeriodGuide from './CtrPeriodGuide';
import CtrDemandGuide from './CtrDemandGuide';
import CommentListFlameGuide from '../../preference/comment/CommentListFlameGuide';
import { openCommentListFlameGuide } from '../../../modules/preference/pubNoteModule';
import { getCtrPtRequest, deleteContractRequest, openCtrSplitGuide, openCtrStandardGuide, openCtrLimitPriceGuide, openPeriodGuide, openDemandGuide } from '../../../modules/preference/contractModule';

// 予約方法の編集
const CslMethod = ({ data }) => {
  // 予約方法
  const cslMethodNum = ['', '本人TEL(全部)', '本人TEL(FAX有り)', '本人E-MAIL', '担当者TEL(全部)', '担当者仮枠(FAX)', '担当者リスト', '担当者E-MAIL', '担当者仮枠(郵送)'];
  let cslMethod;
  if (data.cslmethod !== null && data.cslmethod <= 8) {
    cslMethod = cslMethodNum[data.cslmethod];
  } else {
    cslMethod = '';
  }
  return cslMethod;
};

class CtrDetailListCtrPtHeader extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.ctrptcd = match.params.ctrptcd;
    this.cscd = match.params.cscd;
    this.orgcd1 = match.params.orgcd1;
    this.orgcd2 = match.params.orgcd2;
    this.handleDeleteClick = this.handleDeleteClick.bind(this);
  }
  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { headerRefresh, onLoad } = this.props;
    if (nextProps.headerRefresh !== headerRefresh && nextProps.headerRefresh) {
      // onLoadアクションの引数として渡す
      const { params } = this.props.match;
      onLoad(params);
    }
  }
  // 削除処理
  handleDeleteClick() {
    const { onSubmitClick, match, history } = this.props;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この契約情報を削除します。よろしいですか？')) {
      return;
    }
    const { orgcd1, orgcd2 } = match.params;
    onSubmitClick(match.params, () => history.replace(`/contents/preference/contract/organization/${orgcd1}/${orgcd2}/courses`));
  }
  // コメント
  handleOpenNoteGuideClick() {
    const { match, onOpenNoteGuide } = this.props;
    const params = {};
    params.orgcd1 = match.params.orgcd1;
    params.orgcd2 = match.params.orgcd2;
    params.dispmode = '4';
    params.cmtmode = '0,0,0,1';
    params.userid = 'HAINS$';
    params.ctrptcd = match.params.ctrptcd;

    onOpenNoteGuide(params);
  }
  render() {
    const { data, match, message, history, onOpenCtrStandardGuide, onOpenLimitGuide, onOpenCtrSplitGuide, onOpenDemandGuide, onOpenPeriodGuide } = this.props;
    return (
      <div >
        <SectionBar title="現在の契約情報" />
        <MessageBanner messages={message} />
        <div>
          <Button onClick={() => { onOpenCtrStandardGuide(); }} value="基本情報" />
          {data && (data.limitrate > 0 || data.limitprice > 0) ?
            <Button style={{ backgroundColor: '#98BCF1' }} onClick={() => { onOpenLimitGuide(); }} value="限度額の設定" />
            :
            <Button onClick={() => { onOpenLimitGuide(); }} value="限度額の設定" />
          }
          <Button onClick={() => { onOpenDemandGuide(data); }} value="負担元情報" />
          <Button onClick={() => { onOpenPeriodGuide(match.params); }} value="契約期間を変更" />
          <Button onClick={() => { onOpenCtrSplitGuide(); }} value="契約期間を分割" />
          <Button onClick={() => this.handleOpenNoteGuideClick()} value="コメント" />
          <Button onClick={() => this.handleDeleteClick()} value="削除" />
          <Button onClick={() => history.push(`/contents/preference/contract/organization/${match.params.orgcd1}/${match.params.orgcd2}/courses`)} value="契約コース一覧へ" />
        </div>
        <FieldGroup itemWidth={90}>
          <FieldSet>
            <FieldItem>受診コース</FieldItem>
            <strong><LabelCourse cscd={match.params.cscd} ctrCsName={data.csname} mark /></strong>
          </FieldSet>
          <FieldSet>
            <FieldItem>契約期間</FieldItem>
            <strong>{moment(data.strdate).format('YYYY年M月D日')}～{moment(data.enddate).format('YYYY年M月D日')}</strong>
            &nbsp;&nbsp;パターンNo.：<b>{match.params.ctrptcd}</b>
            &nbsp;&nbsp;年齢起算日：
            {data.agecalc && data.agecalc.length === 8 && (
              <span>
                <strong>
                  {Number.parseInt(`${data.agecalc}`.substr(0, 4), 10)}年{Number.parseInt(`${data.agecalc}`.substr(4, 2), 10)}月{Number.parseInt(`${data.agecalc}`.substr(6, 2), 10)}日
                </strong>
              </span>
            )}
            {data.agecalc && `${data.agecalc}`.length === 4 && (
              <span ><strong>{Number.parseInt(`${data.agecalc}`.substr(0, 2), 10)}月{Number.parseInt(`${data.agecalc}`.substr(2, 2), 10)}日</strong></span>
            )}
            {(data.agecalc === null || data.agecalc === undefined) && (
              <span color="#666666">（受診日時点の年齢で起算）</span>
            )}
          </FieldSet>
          <FieldSet>
            <FieldItem>予約方法</FieldItem>
            <strong><CslMethod data={data} /></strong>
          </FieldSet>
        </FieldGroup>
        <CtrStandardGuide {...this.props} orgcd1={match.params.orgcd1} orgcd2={match.params.orgcd2} ctrptcd={match.params.ctrptcd} />
        <CtrSplitPeriodGuide {...this.props} orgcd1={match.params.orgcd1} orgcd2={match.params.orgcd2} ctrptcd={match.params.ctrptcd} />
        <CtrLimitPriceGuide ctrptcd={match.params.ctrptcd} orgcd1={match.params.orgcd1} orgcd2={match.params.orgcd2} />
        <CtrPeriodGuide orgcd1={match.params.orgcd1} orgcd2={match.params.orgcd2} csCd={match.params.cscd} ctrPtCd={match.params.ctrptcd} />
        <CtrDemandGuide orgCd1={match.params.orgcd1} orgCd2={match.params.orgcd2} csCd={match.params.cscd} ctrPtCd={match.params.ctrptcd} />
        <CommentListFlameGuide />
      </div>
    );
  }
}

CtrDetailListCtrPtHeader.propTypes = {
  onSubmitClick: PropTypes.func.isRequired,
  onOpenCtrStandardGuide: PropTypes.func.isRequired,
  onOpenLimitGuide: PropTypes.func.isRequired,
  onOpenCtrSplitGuide: PropTypes.func.isRequired,
  onOpenDemandGuide: PropTypes.func.isRequired,
  onOpenPeriodGuide: PropTypes.func.isRequired,
  onOpenNoteGuide: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  match: PropTypes.shape().isRequired,
  data: PropTypes.shape().isRequired,
  headerRefresh: PropTypes.bool.isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  data: state.app.preference.contract.ctrDetailList.data,
  message: state.app.preference.contract.contractEdit.message,
  headerRefresh: state.app.preference.contract.ctrDetailList.headerRefresh,
});

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    dispatch(getCtrPtRequest(params));
  },
  // 削除処理
  onSubmitClick: (data, redirect) => {
    dispatch(deleteContractRequest({ data, redirect }));
  },
  // 基本情報
  onOpenCtrStandardGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openCtrStandardGuide());
  },
  // 限度額の設定
  onOpenLimitGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openCtrLimitPriceGuide());
  },
  // 負担元情報
  onOpenDemandGuide: (data) => {
    // 開くアクションを呼び出す
    dispatch(openDemandGuide(data));
  },
  // 契約期間を変更
  onOpenPeriodGuide: (data) => {
    const { cscd } = data;
    // 開くアクションを呼び出す
    dispatch(openPeriodGuide({ cscd }));
  },
  // 契約期間を分割
  onOpenCtrSplitGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openCtrSplitGuide());
  },
  // コメント
  onOpenNoteGuide: (params) => {
    dispatch(openCommentListFlameGuide({ params }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(CtrDetailListCtrPtHeader));
