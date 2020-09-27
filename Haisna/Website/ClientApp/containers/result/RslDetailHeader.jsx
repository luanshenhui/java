import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import { Field, reduxForm, getFormValues, formValueSelector, blur } from 'redux-form';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import DropDownSelectGrpDiv from '../../components/control/dropdown/DropDownSelectGrpDiv';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import Button from '../../components/control/Button';
import CheckBox from '../../components/control/CheckBox';
import MessageBanner from '../../components/MessageBanner';
import { updateResultForDetailRequest, showArticleResult, rslMainShowRequest, getCurRsvNoPrevNextRequest } from '../../modules/result/resultModule';

const formName = 'RslDetailHeader';

const iconvplay = (
  <svg width="12" height="12" viewBox="0 0 1024 1024" fill="#CCCCCC">
    <path d="M773.328 448l-522.672-448v896z" />
  </svg>);
const iconvback = (
  <svg width="12" height="12" viewBox="0 0 1024 1024" fill="#CCCCCC">
    <path d="M250.656 448l522.672 448v-896z" />
  </svg>);


const prefixInteger = (dayid) => {
  let res;
  if (dayid && dayid.toString().length === 1) {
    res = `000${dayid}`;
  } else if (dayid && dayid.toString().length === 2) {
    res = `00${dayid}`;
  } else if (dayid && dayid.toString().length === 3) {
    res = `0${dayid}`;
  } else if (dayid && dayid.toString().length === 4) {
    res = `${dayid}`;
  }
  return res;
};
// 印刷ボタン制御
const showPrint = (workstation, rslListData, curRsvNoPrevNext) => {
  const res = [];

  if (rslListData === null || rslListData === undefined) {
    return res;
  }
  if (rslListData.length === 0) {
    return res;
  }
  // 要入力項目が存在しない場合は非表示
  if (rslListData.upditemcount === 0) {
    return res;
  }
  // 端末情報が存在しなければ非表示
  if (workstation === null || workstation === '') {
    return res;
  }
  // 印刷ボタン表示値がなければ表示しない
  if (workstation && workstation.isprintbutton !== 1 && workstation.isprintbutton !== 2) {
    return res;
  }
  // 女性の場合のみ乳房検査票印刷ボタンを表示
  if (curRsvNoPrevNext && curRsvNoPrevNext !== null && curRsvNoPrevNext.gender === 2) {
    res.push(<Button value="乳房検査票印刷" />);
  } else if (workstation.isprintbutton === 1) {
    res.push(<Button value="超音波検査表を印刷" />);
  } else {
    res.push(<Button value="口腔疾患検査結果表を印刷" />);
  }

  if (workstation && workstation.isprintbutton === 1) {
    res.push(<span>有所見者は自動で超音波検査票を出力</span>);
    res.push(<Field name="echo" component={CheckBox} />);
  }

  return res;
};

class RslDetailHeader extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleSaveClick = this.handleSaveClick.bind(this);
    this.setDefaultValue = this.setDefaultValue.bind(this);
  }
  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { onSubmit, conditions, curRsvNoPrevNext, headerRefresh, formValues } = this.props;
    if (formValues) {
      conditions.code = formValues.code;
    }
    if (formValues && formValues.code === undefined) {
      conditions.code = 'all';
    }
    if (conditions.dayid !== null) {
      conditions.noprevnext = 1;
    }
    if (nextProps && nextProps.mode !== undefined) {
      conditions.mode = nextProps.mode;
    }

    if (curRsvNoPrevNext) {
      conditions.rsvno = curRsvNoPrevNext.rsvno;
    }
    if (nextProps.headerRefresh !== headerRefresh && nextProps.headerRefresh) {
      // onLoadアクションの引数として渡す
      onSubmit(conditions);
    }
  }

  // デフォルト値の展開処理
  setDefaultValue() {
    const { detailFormValues, setValue } = this.props;
    let objResult;
    let objDefResult;
    let objDefShortStc;
    for (let i = 0; i < detailFormValues.rslListData.length; i += 1) {
      objResult = detailFormValues.rslListData[i].result;
      objDefResult = detailFormValues.rslListData[i].defresult;
      objDefShortStc = detailFormValues.rslListData[i].defshortstc;
      if (objResult === '' && objDefResult !== null) {
        setValue(`rslListData[${i}].result`, objDefResult);
        setValue(`rslListData[${i}].shortstc`, objDefShortStc);
      }
    }
  }
  // 保存
  handleSaveClick() {
    const { onSave, curRsvNoPrevNext, rslListData, detailFormValues, workstation, onPrint, formValues } = this.props;
    const params = {};
    params.rsvno = curRsvNoPrevNext.rsvno;
    params.formData = detailFormValues.rslListData;
    params.rslListData = rslListData;
    params.isprintbutton = null;
    params.echo = null;
    if (workstation !== null) {
      params.isprintbutton = workstation.isprintbutton;
    }
    if (formValues.echo !== undefined) {
      params.echo = formValues.echo;
    }
    onSave(params, (rec) => onPrint(rec));
  }
  // 表示
  handleSubmit(values) {
    const { onSubmit, conditions, curRsvNoPrevNext } = this.props;
    conditions.code = values.code;
    if (values.code === undefined) {
      conditions.code = 'all';
    }
    if (conditions.dayid !== null) {
      conditions.noprevnext = 1;
    }
    if (curRsvNoPrevNext) {
      conditions.rsvno = curRsvNoPrevNext.rsvno;
    }
    onSubmit(conditions);
  }
  // 前後受診者の入力画面へ
  showPrevNextPage(state) {
    const { csldate, cscd, sortkey, cntlno, rslDailyListHeaderConditions, curRsvNoPrevNext, onShowNextPage, formValues } = this.props;
    const params = { };
    params.needUnReceiptConsult = true;
    params.csldate = csldate;
    params.rsvno = curRsvNoPrevNext.rsvno;
    params.sortkey = sortkey;
    params.cntlno = cntlno;
    if (formValues.code !== '') {
      params.code = formValues.code;
    }
    if (cscd !== null && cscd !== '' && cscd !== undefined) {
      params.cscd = cscd;
    }
    params.state = state;
    params.rslDailyListHeaderConditions = rslDailyListHeaderConditions;
    onShowNextPage(params);
  }
  // 表示モードの切り替え
  handleShowArticleResultClick() {
    const { onShowArticleResult } = this.props;
    onShowArticleResult();
  }


  // 描画処理
  render() {
    const { handleSubmit, message, curRsvNoPrevNext, resultFlg, prevrsvno, nextrsvno, workstation, rslListData, codename, mode, upditemcount } = this.props;
    return (
      <div>
        <span style={{ fontSize: '18px', color: '#006699', display: prevrsvno === null ? 'none' : '' }}>
          <a role="presentation" onClick={() => this.showPrevNextPage(1)} style={{ cursor: 'pointer' }}>
            {iconvback}
          </a>
        </span>
        <span style={{ marginLeft: '30px', fontSize: '18px', color: '#006699', display: nextrsvno === null ? 'none' : '' }}>
          <a role="presentation" onClick={() => this.showPrevNextPage(2)} style={{ cursor: 'pointer' }}>
            {iconvplay}
          </a>
        </span>
        {mode === 0 &&
          <Button type="submit" value="経年変化" />
        }
        <Button onClick={this.handleSaveClick} value="保存" />
        <Button onClick={this.setDefaultValue} value="デフォルト値を展開" />
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <MessageBanner messages={message} />
          <FieldGroup>
            <FieldSet>
              <FieldItem><nobr>検査日</nobr></FieldItem>
              <Label><nobr><font color="#ff6600"><b>{moment(curRsvNoPrevNext.csldate).format('YYYY/MM/DD')}</b></font></nobr></Label>
              <FieldItem><nobr>受診コース</nobr></FieldItem>
              <Label><nobr><font color="#ff6600"><b>{curRsvNoPrevNext.csname}</b></font></nobr></Label>
              <FieldItem><nobr>当日ＩＤ</nobr></FieldItem>
              <Label><nobr><font color="#ff6600"><b>{prefixInteger(curRsvNoPrevNext.dayid)}</b></font></nobr></Label>
              <FieldItem><nobr>予約番号</nobr></FieldItem>
              <Label><nobr><font color="#ff6600"><b>{curRsvNoPrevNext.rsvno}</b></font></nobr></Label>
            </FieldSet>
            <FieldSet>
              <Label>{curRsvNoPrevNext.perid}</Label>
              <Label><b>{curRsvNoPrevNext.lastname}&nbsp;&nbsp;&nbsp;{curRsvNoPrevNext.firstname}</b></Label>
              <Label>({curRsvNoPrevNext.lastkname}&nbsp;&nbsp;&nbsp;{curRsvNoPrevNext.firstkname})</Label>
            </FieldSet>
            <FieldSet>
              <div style={{ paddingLeft: '75px' }}>
                {curRsvNoPrevNext.birthyearshorteraname}{curRsvNoPrevNext.birtherayear} {moment(curRsvNoPrevNext.birth).format('MM.DD')}生&nbsp;&nbsp;
                {curRsvNoPrevNext.age}歳&nbsp;&nbsp;
                {curRsvNoPrevNext.gender === 1 ? '男性' : '女性'}
              </div>
            </FieldSet>
            {mode === 0 &&
              <FieldSet>
                <FieldItem><nobr>入力用検査項目セット</nobr></FieldItem>
                <Field name="code" component={DropDownSelectGrpDiv} grpDiv="2" addblank blankname="すべて" />
                <Button type="submit" value="表示" />
              </FieldSet>
            }
            {mode === 1 &&
              <FieldSet>
                判定分類({codename})に該当する検査項目を表示しています。
              </FieldSet>
            }
            {mode === 2 &&
              <FieldSet>
                進捗管理分類({codename})に該当する検査項目を表示しています。
              </FieldSet>
            }
            <FieldSet>
              <span style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}>
                <a role="presentation" onClick={() => (this.handleShowArticleResultClick())} >
                  文章結果を表示{resultFlg ? 'しない' : 'する'}
                </a>
              </span>
              {showPrint(workstation, rslListData)}
            </FieldSet>
            {upditemcount === 0 && mode === 0 &&
              <FieldSet>
                <div style={{ color: '#FF9900', fontWeight: 'bolder', fontSize: '14px' }}>
                  この入力検査項目セット内に受診項目は存在しません。
                </div>
              </FieldSet>
            }
            {upditemcount === 0 && mode === 1 &&
              <FieldSet>
                <div style={{ color: '#FF9900', fontWeight: 'bolder', fontSize: '14px' }}>
                判定分類（{codename}）に受診項目は存在しません。
                </div>
              </FieldSet>
            }
            {upditemcount === 0 && mode === 2 &&
              <FieldSet>
                <div style={{ color: '#FF9900', fontWeight: 'bolder', fontSize: '14px' }}>
                進捗管理分類（{codename}）に受診項目は存在しません。
                </div>
              </FieldSet>
            }
          </FieldGroup>
        </form>
      </div>
    );
  }
}

// propTypesの定義
RslDetailHeader.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onPrint: PropTypes.func.isRequired,
  onSave: PropTypes.func.isRequired,
  onShowArticleResult: PropTypes.func.isRequired,
  onShowNextPage: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  csldate: PropTypes.string.isRequired,
  cscd: PropTypes.string.isRequired,
  sortkey: PropTypes.string.isRequired,
  cntlno: PropTypes.string.isRequired,
  prevrsvno: PropTypes.string.isRequired,
  nextrsvno: PropTypes.string.isRequired,
  codename: PropTypes.string.isRequired,
  conditions: PropTypes.shape().isRequired,
  curRsvNoPrevNext: PropTypes.shape().isRequired,
  rslListData: PropTypes.shape().isRequired,
  workstation: PropTypes.shape().isRequired,
  formValues: PropTypes.shape().isRequired,
  rslDailyListHeaderConditions: PropTypes.shape().isRequired,
  detailFormValues: PropTypes.shape().isRequired,
  resultFlg: PropTypes.bool.isRequired,
  headerRefresh: PropTypes.bool.isRequired,
  mode: PropTypes.bool.isRequired,
  upditemcount: PropTypes.number.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
};

const RslDetailHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'RslDetailHeader',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(RslDetailHeader);

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  const detailFormValues = getFormValues('RslDetailBody')(state);
  const selector = formValueSelector('rslDailyListHeader');
  return {
    formValues,
    initialValues: {
      rslListData: state.app.result.result.rslDailyList.rslListData.item,
      resultFlg: state.app.result.result.rslDetail.resultFlg,
      lastInfo: state.app.result.result.rslDailyList.lastInfo,
      code: state.app.result.result.rslDetail.code,
    },
    curRsvNoPrevNext: state.app.result.result.rslDailyList.curRsvNoPrevNext,
    codename: state.app.result.result.rslDailyList.codename,
    mode: state.app.result.result.rslDailyList.mode,
    resultFlg: state.app.result.result.rslDetail.resultFlg,
    conditions: state.app.result.result.rslMain.conditions,
    message: state.app.result.result.rslDetail.message,
    workstation: state.app.result.result.rslDetail.workstation,
    rslListData: state.app.result.result.rslDailyList.rslListData.item,
    upditemcount: state.app.result.result.rslDailyList.rslListData.upditemcount,
    csldate: state.app.result.result.rslMain.conditions.csldate,
    cscd: state.app.result.result.rslMain.conditions.cscd,
    sortkey: state.app.result.result.rslMain.conditions.sortkey,
    cntlno: state.app.result.result.rslMain.conditions.cntlno,
    prevrsvno: state.app.result.result.rslDetail.prevrsvno,
    nextrsvno: state.app.result.result.rslDetail.nextrsvno,
    headerRefresh: state.app.result.result.rslDetail.headerRefresh,
    rslDailyListHeaderConditions: {
      csldate: selector(state, 'csldate'),
      cscd: selector(state, 'cscd'),
      sortkey: selector(state, 'sortkey'),
      cntlno: selector(state, 'cntlno'),
    },
    detailFormValues,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onShowArticleResult() {
    dispatch(showArticleResult());
  },
  onSubmit: (params) => {
    dispatch(rslMainShowRequest({ params }));
  },
  onSave: (params, onPrint) => {
    dispatch(updateResultForDetailRequest({ params, onPrint }));
  },
  onShowNextPage: (params) => {
    dispatch(getCurRsvNoPrevNextRequest(params));
  },
  onPrint: (rec) => {
    if (rec === 1) {
      // TODO
    }
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur('RslDetailBody', name, value));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RslDetailHeaderForm));
