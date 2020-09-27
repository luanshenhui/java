import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import { Field, getFormValues, reduxForm, blur, FieldArray } from 'redux-form';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import CheckBox from '../../components/control/CheckBox';
import DropDown from '../../components/control/dropdown/DropDown';
import Button from '../../components/control/Button';
import MessageBanner from '../../components/MessageBanner';
import FollowInfoBodyItems from './FollowInfoBodyItems';
import CommentListFlame from '../../containers/preference/comment/CommentListFlameGuide';
import { openCommentListFlameGuide } from '../../modules/preference/pubNoteModule';
import {
  getTargetFollowInfoRequest,
  getConsultInfoRequest,
  registerFollowInfoRequest,
  openFolUpdateHistoryGuide,
  getFolReqHistoryRequest,
  openFollowInfoEditGuideRequest,
  openFollowReqEditGuideRequest,
} from '../../modules/followup/followModule';

const formName = 'FollowInfoBody';

class FollowInfoBody extends React.Component {
  constructor(props) {
    super(props);
    // 保存ボタンクリック
    this.handleSubmit = this.handleSubmit.bind(this);
    // 検索ボタンクリック
    this.handleTargetFollowClick = this.handleTargetFollowClick.bind(this);
    // チャート情報クリック
    this.handleCommentClick = this.handleCommentClick.bind(this);
    // 変更履歴クリック
    this.handleFolUpdateHistoryClick = this.handleFolUpdateHistoryClick.bind(this);
    // 印刷履歴クリック
    this.handleFollowReqHistoryClick = this.handleFollowReqHistoryClick.bind(this);
    // 結果入力クリック
    this.handleResultClick = this.handleResultClick.bind(this);
    // 依頼状作成クリック
    this.handleRequestClick = this.handleRequestClick(this);
  }

  componentDidMount() {
    const { onLoad, match, setValue } = this.props;
    onLoad(match.params);
    // 表示受診日初期値をセット
    setValue('csldate', match.params.rsvno);
  }

  // 保存ボタンクリック時の処理
  handleSubmit(values) {
    const { onSubmit, targetFollowData } = this.props;
    if (targetFollowData && targetFollowData.length > 0) {
      onSubmit(values);
    }
  }

  // 検索ボタンクリック時の処理
  handleTargetFollowClick() {
    const { onSearch } = this.props;
    onSearch(this.props);
  }

  // チャート情報ボタンクリック時の処理
  handleCommentClick(values) {
    const { onOpenCommentGuide, match } = this.props;
    onOpenCommentGuide(match, values);
  }

  // 変更履歴ボタンクリック時の処理
  handleFolUpdateHistoryClick() {
    const { onOpenFolUpdateHistoryGuide, match } = this.props;
    onOpenFolUpdateHistoryGuide(match.params);
  }

  // 印刷履歴ボタンクリック時の処理
  handleFollowReqHistoryClick() {
    const { onOpenFollowReqHistoryGuide, match } = this.props;
    onOpenFollowReqHistoryGuide({ ...match.params });
  }

  // 結果入力クリック時画面呼び出し
  handleResultClick(rsvno, judclasscd) {
    const { onOpenFollowInfoEditGuide } = this.props;
    onOpenFollowInfoEditGuide(rsvno, judclasscd);
  }

  // 依頼状作成クリック時画面呼び出し
  handleRequestClick(rsvno, judclasscd) {
    const { onOpenFollowReqEditGuide } = this.props;
    onOpenFollowReqEditGuide(rsvno, judclasscd);
  }

  render() {
    const { handleSubmit, message, consultData, followHistoryData, targetFollowData, match, formValues, winmode, pubNoteData } = this.props;
    const csldateHistoryItems = followHistoryData && followHistoryData.map((rec) => ({ value: rec.rsvno, name: moment(rec.csldate).format('YYYY/MM/DD') }));
    const csldateitem = moment(consultData && consultData.csldate).format('YYYY/MM/DD');
    const csldateItems = match && [{ value: match.params.rsvno, name: csldateitem }];

    // 依頼状印刷クリック時画面呼び出し
    function handlePrintClick(seq) {
      open(`/api/v1/reports/${seq}`);
    }

    const commentParams = () => {
      // チャート情報
      const { csldate } = formValues;
      let csldatetext = null;
      if (followHistoryData && followHistoryData.length === 0) {
        const element = csldateItems.find((rec) => (rec.value.toString() === csldate));
        csldatetext = element ? element.name : '';
      } else {
        const element = csldateHistoryItems.find((rec) => (rec.value.toString() === csldate));
        csldatetext = element ? element.name : '';
      }
      match.params.pubnotedivcd = '500';
      match.params.dispmode = '2';
      match.params.dispkbn = '1';
      match.params.cmtmode = '1,1,0,0';
      match.params.startdate = csldatetext;
      match.params.enddate = csldatetext;
      return match;
    };

    const TargetFollowDataFields = (
      <FieldArray
        name="targetFollowData"
        targetFollowData={targetFollowData}
        handleResultClick={this.handleResultClick}
        handleRequestClick={this.handleRequestClick}
        handlePrintClick={handlePrintClick}
        winmode={winmode}
        component={FollowInfoBodyItems}
        formName={formName}
      />);

    return (
      <div>      
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <div style={{ marginTop: '10px', marginBottom: '10px' }}>
            {(pubNoteData && pubNoteData.length > 0) ?
              <Button onClick={handleSubmit((values) => this.handleCommentClick(values))} value="チャート情報_UP" /> :
              <Button onClick={handleSubmit((values) => this.handleCommentClick(values))} value="チャート情報" />}
            <Button onClick={() => this.handleFolUpdateHistoryClick()} value="変更履歴" />
            <Button onClick={() => this.handleFollowReqHistoryClick()} value="印刷履歴" />
          </div>
          <MessageBanner messages={message} />
          <FieldGroup>
            <FieldSet>
              <FieldItem>表示受診日</FieldItem>
              {(followHistoryData && followHistoryData.length === 0) ?
                <Field name="csldate" component={DropDown} items={csldateItems} /> : <Field name="csldate" component={DropDown} items={csldateHistoryItems} />
              }
              <Button onClick={handleSubmit(() => this.handleTargetFollowClick())} value="検索" />
              <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />
            </FieldSet>
            <Field component={CheckBox} name="judFlg" checkedValue={1} label="判定結果が登録されていない検査項目も表示" />
            <span>&nbsp;</span>
          </FieldGroup>
          <FieldGroup>
            {(winmode === '1') ?
              <FieldSet>
                <div style={{ width: '900px' }} />
                面接支援 &nbsp;&nbsp;&nbsp;&nbsp; 依頼状印刷 &nbsp;&nbsp;&nbsp;&nbsp; 結果入力
              </FieldSet>
              :
              <FieldSet>
                <div style={{ width: '800px' }} />
                依頼状印刷 &nbsp;&nbsp;&nbsp;&nbsp; 結果入力
              </FieldSet>
            }
          </FieldGroup>
          <div>
            {TargetFollowDataFields}
          </div>
        </form>
        <CommentListFlame match={{ params: { ...commentParams().params, winmode: '1' } }} />
      </div>
    );
  }
}

const FollowInfoBodyForm = reduxForm({
  form: formName,
})(FollowInfoBody);

FollowInfoBody.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  consultData: PropTypes.shape(),
  followHistoryData: PropTypes.arrayOf(PropTypes.shape()),
  targetFollowData: PropTypes.arrayOf(PropTypes.shape()),
  onSearch: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  onOpenCommentGuide: PropTypes.func,
  formValues: PropTypes.shape(),
  winmode: PropTypes.string,
  pubNoteData: PropTypes.arrayOf(PropTypes.shape()),
  onOpenFolUpdateHistoryGuide: PropTypes.func.isRequired,
  onOpenFollowReqHistoryGuide: PropTypes.func.isRequired,
  onOpenFollowInfoEditGuide: PropTypes.func.isRequired,
  onOpenFollowReqEditGuide: PropTypes.func.isRequired,
};

FollowInfoBody.defaultProps = {
  targetFollowData: [],
  followHistoryData: [],
  consultData: {},
  onOpenCommentGuide: null,
  formValues: {},
  winmode: undefined,
  pubNoteData: [],
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    initialValues: {
      targetFollowData: [],
      csldate: '',
    },
    formValues,
    message: state.app.followup.follow.followInfo.message,
    consultData: state.app.followup.follow.followInfo.consultData,
    followHistoryData: state.app.followup.follow.followInfo.followHistoryData,
    targetFollowData: state.app.followup.follow.followInfo.targetFollowData,
    pubNoteData: state.app.followup.follow.followInfo.pubNoteData,
  };
};

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    const { rsvno } = params;
    if (rsvno === undefined) {
      return;
    }

    if (rsvno !== null) {
      // 受診情報読み込み
      dispatch(getConsultInfoRequest(params));
    }

    if (rsvno !== null) {
      dispatch(getTargetFollowInfoRequest({ rsvno, judFlg: false, formName }));
    }
  },

  onSearch: (props) => {
    const { csldate } = props.formValues;
    const { judFlg } = props.formValues;
    let parajudFlg = false;

    if (judFlg === 0 || judFlg === null || judFlg === undefined) {
      parajudFlg = false;
    } else {
      parajudFlg = true;
    }
    dispatch(getTargetFollowInfoRequest({ rsvno: csldate, judFlg: parajudFlg, formName }));
  },

  onSubmit: (data) => {
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この内容で保存します。よろしいですか？')) {
      return;
    }

    const followResult = [];
    data.targetFollowData.map((item) => (
      (item.equipdiv === null && item.secequipdiv !== undefined && item.secequipdiv !== null) &&
      followResult.push({ rsvno: item.rsvno, judclasscd: item.judclasscd, secequipdiv: item.secequipdiv, judcd: item.rsljudcd })
    ));

    const { csldate } = data;
    const { judFlg } = data;
    let parajudFlg = false;

    if (judFlg === 0 || judFlg === null || judFlg === undefined) {
      parajudFlg = false;
    } else {
      parajudFlg = true;
    }

    dispatch(registerFollowInfoRequest({ data: { ...data, followResult }, rsvno: csldate, judFlg: parajudFlg, formName }));
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },

  onOpenCommentGuide: () => {
    // チャート情報画面呼び出
    dispatch(openCommentListFlameGuide());
  },

  onOpenFolUpdateHistoryGuide: (params) => {
    // 変更履歴画面呼び出
    dispatch(openFolUpdateHistoryGuide({ ...params, winmode: '1' }));
  },

  onOpenFollowReqHistoryGuide: (params) => {
    // 印刷履歴画面呼び出
    dispatch(getFolReqHistoryRequest(params));
  },

  // フォローアップ結果入力情報編集画面呼び出
  onOpenFollowInfoEditGuide: (rsvno, judclasscd) => {
    dispatch(openFollowInfoEditGuideRequest({ rsvno, judclasscd }));
  },

  // フォロー依頼状作成画面呼び出
  onOpenFollowReqEditGuide: (rsvno, judclasscd) => {
    dispatch(openFollowReqEditGuideRequest({ rsvno, judclasscd }));
  },

});

export default (connect(mapStateToProps, mapDispatchToProps)(FollowInfoBodyForm));
