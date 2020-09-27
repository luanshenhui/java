import React from 'react';
import { reduxForm, getFormValues } from 'redux-form';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import Button from '../../components/control/Button';
import PageLayout from '../../layouts/PageLayout';
import PrepaInfoDiseaseBody from './PrepaInfoDiseaseBody';
import PrepaInfoCmntHisBody from './PrepaInfoCmntHisBody';
import PrepaInfoBasic from './PrepaInfoBasic';
import MessageBanner from '../../components/MessageBanner';
import { loadPreparationInfoRequest, mergePerResultRequest, deletePerResultRequest } from '../../modules/reserve/consultModule';
import { getFollowBeforeRequest, openFollowInfoGuide } from '../../modules/followup/followModule';
import { getEditOcrDateRequest } from '../../modules/dailywork/questionnaireModule';
import { openOcrNyuryouku } from '../../modules/dailywork/questionnaire1Module';
import FollowinfoTop from '../judgement/FollowinfoTop';
import OcrNyuryoku from './OcrNyuryoku';

const formName = 'preparationInfo';


class PreparationInfo extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleOpenOcrClick = this.handleOpenOcrClick.bind(this);
    this.handleFollowupBeforeClick = this.handleFollowupBeforeClick.bind(this);
    this.handleEditCsvClick = this.handleEditCsvClick.bind(this);
  }

  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  // 保存
  handleSubmit(values) {
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('個人基本情報を登録します。よろしいですか？')) {
      return;
    }
    const data = {};
    // 変更項目
    const mergePerResult = {};
    // 削除項目
    const deletePerResult = {};
    const perresultitem = [];
    const perresult = {};


    const { onSubmit, perResult, consult } = this.props;
    let updCount = 0;
    let delCount = 0;
    const delItemCd = [];
    const delSuffix = [];

    const { perid } = consult;

    for (let i = 0; i < perResult.perResultGrp.length; i += 1) {
      if (values.edtResult[i] !== perResult.perResultGrp[i].result) {
        if (values.edtResult[i] === '') {
          delItemCd.push(perResult.perResultGrp[i].itemcd);
          delSuffix.push(perResult.perResultGrp[i].suffix);
          delCount = 1;
        } else {
          perresultitem.push({
            itemcd: perResult.perResultGrp[i].itemcd,
            suffix: perResult.perResultGrp[i].suffix,
            result: values.edtResult[i],
            ispdate: perResult.perResultGrp[i].ispdate,
            upddiv: '0',
          });
          updCount = 1;
        }
      }
    }

    perresult.perresultitem = perresultitem;
    perresult.perid = perid;

    mergePerResult.perresult = perresult;

    deletePerResult.perId = perid;
    deletePerResult.itemCd = delItemCd;
    deletePerResult.suffix = delSuffix;


    data.mergePerResult = mergePerResult;
    data.deletePerResult = deletePerResult;
    data.updCount = updCount;
    data.delCount = delCount;
    onSubmit(data);
  }

  // 「OCR入力結」ボタンクリック時の処理
  handleOpenOcrClick() {
    const { onOpenOcr } = this.props;

    onOpenOcr();
  }
  // 「前回フォローアップ情報」ボタンクリック時の処理
  handleFollowupBeforeClick() {
    const { onOpenFollowInfoGuide } = this.props;
    onOpenFollowInfoGuide();
  }
  // 「CSVファイル作成」ボタンクリック時の処理
  handleEditCsvClick() {
    const { onEditCsv } = this.props;

    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('ＭＣＨ連携用ファイルを作成します。よろしいですか？')) {
      return;
    }

    onEditCsv();
  }

  render() {
    const { consult, org, prepaInfoDisease, prepaInfoCmntHis, handleSubmit, allInfo, message,
      followBeforeData, editOcrDate, match } = this.props;
    const { rsvno } = match.params;
    return (
      <PageLayout title="問診入力">
        <div>
          <div>
            <Button onClick={this.handleOpenOcrClick} value="OCR入力結果" />
            {followBeforeData !== '' && followBeforeData !== null && (
              <Button onClick={this.handleFollowupBeforeClick} value="前回フォローアップ情報" />
            )}
            {editOcrDate && editOcrDate.editocrdate !== '' && editOcrDate.editocrdate !== null && (
              <Button onClick={this.handleEditCsvClick} value="メンタルヘルス" />
            )}
          </div>
          <div style={{ float: 'left', marginRight: '8px' }}>
            <div style={{ marginTop: '-4px' }} >
              <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
                <MessageBanner messages={message} />
                <PrepaInfoBasic consult={consult} org={org} allInfo={allInfo} />
              </form>
            </div>
          </div>
          <div style={{ float: 'left', marginRight: '8px' }}>
            <div>
              <PrepaInfoDiseaseBody prepaInfoDisease={prepaInfoDisease} />
              <PrepaInfoCmntHisBody prepaInfoCmntHis={prepaInfoCmntHis} />
              {followBeforeData !== '' && followBeforeData !== null && (
                <FollowinfoTop match={{ params: { rsvno: followBeforeData.rsvno, winmode: '1' } }} />
              )}
            </div>
          </div>
        </div>
        <OcrNyuryoku rsvno={rsvno} />
      </PageLayout>
    );
  }
}

// propTypesの定義
PreparationInfo.propTypes = {
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  org: PropTypes.shape().isRequired,
  consult: PropTypes.shape().isRequired,
  perResult: PropTypes.shape().isRequired,
  allInfo: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  match: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  onOpenOcr: PropTypes.func.isRequired,
  onEditCsv: PropTypes.func.isRequired,
  prepaInfoDisease: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  prepaInfoCmntHis: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  editOcrDate: PropTypes.shape().isRequired,
  followBeforeData: PropTypes.shape().isRequired,
  onOpenFollowInfoGuide: PropTypes.func.isRequired,
};

const PreparationInfoForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(PreparationInfo);

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    consult: state.app.reserve.consult.prepaInfo.consult,
    message: state.app.reserve.consult.prepaInfo.message,
    org: state.app.reserve.consult.prepaInfo.org,
    perResult: state.app.reserve.consult.prepaInfo.perResult,
    allInfo: state.app.reserve.consult.prepaInfo.allInfo,
    edtResult: state.app.reserve.consult.prepaInfo.edtResult,
    stcCount: state.app.reserve.consult.prepaInfo.stcCount,
    prepaInfoDisease: state.app.reserve.consult.prepaInfo.prepaInfoDisease,
    prepaInfoCmntHis: state.app.reserve.consult.prepaInfo.prepaInfoCmntHis,
    prepaInfoReexamin: state.app.reserve.consult.prepaInfo.prepaInfoReexamin,
    prepaInfoSecond: state.app.reserve.consult.prepaInfo.prepaInfoSecond,
    editOcrDate: state.app.dailywork.questionnaire.prepaInfo.editOcrDate,
    followBeforeData: state.app.followup.follow.prepaInfo.followBeforeData,
    initialValues: {
      edtResult: state.app.reserve.consult.prepaInfo.edtResult,
    },
  };
};

const mapDispatchToProps = (dispatch, props) => ({
  // 画面を初期化
  onLoad: (params) => {
    dispatch(getFollowBeforeRequest(params));
    dispatch(getEditOcrDateRequest(params));
    dispatch(loadPreparationInfoRequest(params));
  },
  // OCR入力結果
  onOpenOcr: () => {
    const { match } = props;
    const { rsvno } = match.params;
    dispatch(openOcrNyuryouku({ rsvno }));
  },
  // 前回フォローアップ情報
  onFollowupBefore: (params) => {
    const { match, history } = props;
    const { rsvno } = match;
    const data = {};
    data.winmode = '1';
    data.pubNoteDivCd = '500';
    data.dispMode = 2;
    data.dispKbn = 1;
    data.cmtMode = [1, 1, 0, 0];
    data.rsvno = rsvno;
    history.push(`/contents/dailywork/mntpersonal/${data}/${params}`);
  },
  // CSVファイル作成
  onEditCsv: () => {
    const { match, history } = props;
    const { rsvno } = match;
    history.push(`/contents/dailywork/EditCsvDatMonshin/${rsvno}`);
  },
  // 保存
  onSubmit: (params) => {
    const { mergePerResult, deletePerResult } = params;
    let data = {};
    if (params.updCount > 0) {
      data = mergePerResult;
      dispatch(mergePerResultRequest({ data }));
    }
    if (params.delCount > 0) {
      dispatch(deletePerResultRequest(deletePerResult));
    }
  },
  // 前回フォローアップ情報画面呼び出し
  onOpenFollowInfoGuide: () => {
    // const { rsvno } = params;
    // 開くアクションを呼び出す
    dispatch(openFollowInfoGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(PreparationInfoForm);
