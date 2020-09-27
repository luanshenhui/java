import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import { bindActionCreators } from 'redux';
import { Field, reduxForm, getFormValues, blur } from 'redux-form';
import { connect } from 'react-redux';
import SectionBar from '../../components/SectionBar';
import DropDownSelectGrpDiv from '../../components/control/dropdown/DropDownSelectGrpDiv';
import MessageBanner from '../../components/MessageBanner';
import CheckBox from '../../components/control/CheckBox';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import TextBox from '../../components/control/TextBox';
import Button from '../../components/control/Button';
import Table from '../../components/Table';
import LabelCourse from '../../components/control/label/LabelCourse';
import { getUpdateResultAll, resetAllMessage } from '../../modules/result/resultModule';
import GuideButton from '../../components/GuideButton';
import { getItemsandresults, getGrpItemList, getResetGrpItem } from '../../modules/preference/groupModule';
import CircularProgress from '../../components/control/CircularProgress/CircularProgress';
import { actions as sentenceGuideActions } from '../../modules/common/sentenceGuideModule';

const formName = 'rslAllSetForm';

// 基準値フラグにより色を設定する
const showColor = (stdflg) => {
  let color = '#000000';
  if (stdflg === 'H') {
    color = '#ff0000';
  } else if (stdflg === 'U') {
    color = '#ff4500';
  } else if (stdflg === 'D') {
    color = '#00ffff';
  } else if (stdflg === 'L') {
    color = '#0000ff';
  } else if (stdflg === '*') {
    color = '#ff0000';
  } else if (stdflg === '@') {
    color = '#800080';
  }
  return color;
};

// 背景スタイル
const backColor = (stdflg) => {
  let color = '#ffffff';
  if (stdflg) {
    color = '#ffccff';
  }
  return color;
};

// スタイルを揃える
const rightAs = (stdflg) => {
  let loaction = 'left';
  if (stdflg !== 3 && stdflg !== 4 && stdflg !== 5) {
    loaction = 'right';
  }
  return loaction;
};

class RslAllSetStep2 extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handlKeyClick = this.handlKeyClick.bind(this);
    this.handlBackClick = this.handlBackClick.bind(this);
    this.handlNextClick = this.handlNextClick.bind(this);
    this.handlRestClick = this.handlRestClick.bind(this);
    this.handleResultChange = this.handleResultChange.bind(this);
  }

  // コンポーネントがマウントされた直後に1回だけ呼ばれる処理
  componentDidMount() {
    const { onLoad, params, formValues } = this.props;
    if (formValues.grpcd && formValues.cslDate) {
      params.grpcd = formValues.grpcd;
      params.cscd = formValues.cscd;
      params.cslDate = formValues.cslDate;
      if (params.allResultClear) {
        params.allResultClear = 0;
      }
      onLoad(params);
    }
  }

  // 表示ボタンクリック時の処理
  handleSubmit(values) {
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この内容で検査結果の一括登録を行います。よろしいですか？')) {
      return;
    }
    const { match, onSubmit, formValues } = this.props;
    onSubmit(match.params, values, formValues.zt);
  }

  // ガイド画面の連絡域に検査項目コードを設定の処理
  handlKeyClick() {
    const { onKeyClick, params, formValues, onResetMessage, setValue, render } = this.props;
    if (formValues.allResultClear && formValues.allResultClear[0] === 1) {
      params.allResultClear = 1;
    } else {
      params.allResultClear = 0;
    }
    params.grpcd = formValues.grpcd;
    params.render = render;
    setValue('itemLoad', {});
    onKeyClick(params);
    onResetMessage();
  }

  // デフォルト値を展開
  handlRestClick() {
    const { reLoad, params, formValues, setValue, render } = this.props;
    if (formValues.grpcd && formValues.cslDate) {
      if (formValues.allResultClear && formValues.allResultClear[0] === 1) {
        params.allResultClear = 1;
      } else {
        params.allResultClear = 0;
      }
      if (formValues.itemLoad && formValues.itemLoad.grpcd) {
        params.grpcd = formValues.itemLoad.grpcd;
      } else {
        params.grpcd = formValues.grpcd;
      }
      params.cscd = formValues.cscd;
      params.cslDate = formValues.cslDate;
      params.render = render;
      setValue('itemData', {});
      reLoad(params);
    }
  }

  // 次画面へ遷移
  handlNextClick() {
    const { onNextClick, params, formValues } = this.props;
    params.dayIdF = formValues.dayIdF;
    params.dayIdT = formValues.dayIdT;
    params.grpcd = formValues.grpcd;
    if (formValues.allResultClear && formValues.allResultClear[0] === 1) {
      params.allResultClear = 1;
    } else {
      params.allResultClear = 0;
    }
    onNextClick(params, formValues, formValues.zt);
  }
  // 「戻る」ボタンクリック時の処理
  handlBackClick() {
    const { onBack } = this.props;
    onBack();
  }

  // 検査結果の編集
  handleResultChange(event, index) {
    const { target } = event;
    const { setValue, formValues } = this.props;
    if (formValues.zt === '1') {
      setValue(`itemLoad.data[${index}].defresult`, target.value);
    } else {
      setValue(`itemData.data[${index}].defresult`, target.value);
    }
  }

  // 描画処理
  render() {
    const { handleSubmit, formValues, isLoading, isLoadTwo, actions, getStcGuide, render, message } = this.props;
    return (
      <div>
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <FieldGroup>
            <SectionBar title="Step2：一括して登録する結果値を入力してください。" />
            <FieldSet>
              <FieldItem><nobr>受診日</nobr></FieldItem>
              <Label name="cslDate"><span style={{ color: '#ff6600' }} ><b>{formValues.cslDate}</b></span></Label>
              <Label />
              <FieldItem><nobr>コース</nobr></FieldItem>
              <Label>
                {formValues.cscd !== '' && <nobr><b><LabelCourse cscd={formValues.cscd} style={{ color: '#ff6600' }} /></b></nobr>}
                {formValues.cscd === '' && <nobr><span style={{ color: '#ff6600' }} ><b>全てのコース</b></span></nobr>}
              </Label>
              <Label />
              <FieldItem><nobr>当日ＩＤ</nobr></FieldItem>
              <Label name="">
                <nobr>
                  <span style={{ color: '#ff6600' }}>
                    {formValues.dayIdF && <b>{formValues.dayIdF}</b>}
                    {formValues.dayIdT && <b>～{formValues.dayIdT}</b>}
                    {!formValues.dayIdT && !formValues.dayIdF && <b>すべて</b>}
                  </span>
                </nobr>
              </Label>
            </FieldSet>
            <FieldSet>
              <Label>入力結果グループ</Label>
              <Field name="grpcd" component={DropDownSelectGrpDiv} grpDiv="2" />
              <Label>を</Label>
              <Button onClick={this.handlKeyClick} value="表示" />
            </FieldSet>
            <FieldSet>
              <Field component={CheckBox} name={`allResultClear.${0}`} checkedValue={1} label="このグループの検査結果を全てクリアする" id="allResultClear" />
              <Button onClick={this.handlRestClick} value="デフォルト値展開" />
            </FieldSet>
            <FieldSet>
              <Button onClick={this.handlBackClick} value="戻 る" />
              <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />
              <Button onClick={this.handlNextClick} value="次 へ" />
            </FieldSet>
            <FieldSet>
              <Label>
                <MessageBanner messages={message} />
              </Label>
            </FieldSet>
            <FieldSet>
              <Label>
                {formValues.itemData && formValues.itemData.message && <MessageBanner messages={formValues.itemData.message} />}
              </Label>
            </FieldSet>
          </FieldGroup>
          <Table striped hover>
            <thead>
              <tr>
                <th style={{ textAlign: 'right' }}>検査項目名</th>
                <th colSpan="2">部位</th>
                <th colSpan="2">&nbsp;&nbsp;&nbsp;所見</th>
                <th>部位文章</th>
                <th>所見文章</th>
              </tr>
            </thead>
            <tbody>
              {formValues.zt === '2' && formValues.itemData && formValues.itemData.data && formValues.itemData.data.map((rec, index) => (
                <tr key={`${rec.itemcd}-${rec.itemname}`}>
                  <td align="right" style={{ width: '20%' }}>{rec.itemname}</td>
                  <td style={{ width: '1%' }}>
                    {(rec.resulttype === 1 || rec.resulttype === 2 || rec.resulttype === 4) && rec.itemtype !== 0 &&
                      <GuideButton
                        onClick={() => actions.sentenceGuideOpenRequest({
                          itemCd: rec.itemcd,
                          itemType: rec.itemtype,
                          onConfirm: (itemgrpdata) => getStcGuide(itemgrpdata, formValues.itemData, index, formValues.zt, render),
                        })}
                      />}
                  </td>
                  <td style={{ width: '10%' }}>
                    {rec.resulttype === 5 && rec.itemtype !== 0 && <span><span style={{ color: '#ff6600' }}>{rec.result}</span></span>}
                    {rec.resulttype !== 5 && rec.itemtype !== 0 && <input
                      type="text"
                      value={rec.defresult}
                      name={`itemData.data[${index}].defresult`}
                      component={TextBox}
                      maxLength="8"
                      style={{ backgroundColor: backColor(rec.resulterror), color: showColor(rec.stdflg), width: '92px', textAlign: rightAs(rec.resulttype) }}
                      onChange={(event) => this.handleResultChange(event, index)}
                    />}
                  </td>
                  <td style={{ width: '1%' }}>
                    {(rec.resulttype === 1 || rec.resulttype === 2 || rec.resulttype === 4) && rec.itemtype === 0 &&
                      <GuideButton
                        onClick={() => actions.sentenceGuideOpenRequest({
                          itemCd: rec.itemcd,
                          itemType: rec.itemtype,
                          onConfirm: (itemgrpdata) => getStcGuide(itemgrpdata, formValues.itemData, index, formValues.zt, render),
                        })}
                      />}
                  </td>
                  <td style={{ width: '10%' }}>
                    {rec.resulttype === 5 && rec.itemtype === 0 && <span><span style={{ color: '#ff6600' }}>{rec.result}</span></span>}
                    {rec.resulttype !== 5 && rec.itemtype === 0 && <input
                      type="text"
                      value={rec.defresult}
                      name={`itemData.data[${index}].defresult`}
                      component={TextBox}
                      maxLength="8"
                      style={{ backgroundColor: backColor(rec.resulterror), color: showColor(rec.stdflg), width: '92px', textAlign: rightAs(rec.resulttype) }}
                      onChange={(event) => this.handleResultChange(event, index)}
                    />}
                  </td>
                  <td style={{ width: '28%' }}>{rec.itemtype !== 0 && <span>{rec.shortstc}</span>}</td>
                  <td style={{ width: '30%' }}>{rec.itemtype === 0 && <span>{rec.shortstc}</span>}</td>
                </tr>
              ))}
              {formValues.zt === '1' && formValues.itemLoad && formValues.itemLoad.data && formValues.itemLoad.data.map((rec, index) => (
                <tr key={`${rec.itemcd}-${rec.itemname}`}>
                  <td align="right" style={{ width: '20%' }}>{rec.itemname}</td>
                  <td style={{ width: '1%' }}>
                    {(rec.resulttype === 1 || rec.resulttype === 2 || rec.resulttype === 4) && rec.itemtype !== 0 &&
                      <GuideButton
                        onClick={() => actions.sentenceGuideOpenRequest({
                          itemCd: rec.itemcd,
                          itemType: rec.itemtype,
                          onConfirm: (itemgrpdata) => getStcGuide(itemgrpdata, formValues.itemLoad, index, formValues.zt, render),
                        })}
                      />}
                  </td>
                  <td style={{ width: '10%' }}>
                    {rec.resulttype === 5 && rec.itemtype === 0 && <span />}
                    {rec.resulttype !== 5 && rec.itemtype !== 0 &&
                      <input
                        type="text"
                        value={rec.defresult}
                        name={`itemLoad.data[${index}].defresult`}
                        component={TextBox}
                        id="result"
                        maxLength="8"
                        style={{ backgroundColor: backColor(rec.resulterror), color: showColor(rec.stdflg), width: '92px', textAlign: rightAs(rec.resulttype) }}
                        onChange={(event) => this.handleResultChange(event, index)}
                      />}
                  </td>
                  <td style={{ width: '1%' }}>
                    {(rec.resulttype === 1 || rec.resulttype === 2 || rec.resulttype === 4) && rec.itemtype === 0 &&
                      <GuideButton
                        onClick={() => actions.sentenceGuideOpenRequest({
                          itemCd: rec.itemcd,
                          itemType: rec.itemtype,
                          onConfirm: (itemgrpdata) => getStcGuide(itemgrpdata, formValues.itemLoad, index, formValues.zt, render),
                        })}
                      />}
                  </td>
                  <td style={{ width: '10%' }}>
                    {rec.resulttype === 5 && rec.itemtype === 0 && <span />}
                    {rec.resulttype !== 5 && rec.itemtype === 0 &&
                      <input
                        type="text"
                        value={rec.defresult}
                        name={`itemLoad.data[${index}].defresult`}
                        component={TextBox}
                        id="result"
                        maxLength="8"
                        style={{ backgroundColor: backColor(rec.resulterror), color: showColor(rec.stdflg), width: '92px', textAlign: rightAs(rec.resulttype) }}
                        onChange={(event) => this.handleResultChange(event, index)}
                      />}
                  </td>
                  <td style={{ width: '28%' }}>{rec.itemtype !== 0 && <span>{rec.shortstc}</span>}</td>
                  <td style={{ width: '30%' }}>{rec.itemtype === 0 && <span>{rec.shortstc}</span>}</td>
                </tr>
              ))}
            </tbody>
          </Table>
        </form>
        {isLoading && <CircularProgress />}
        {isLoadTwo && <CircularProgress />}
      </div>
    );
  }
}

// propTypesの定義
RslAllSetStep2.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  reLoad: PropTypes.func.isRequired,
  params: PropTypes.shape(),
  onKeyClick: PropTypes.func.isRequired,
  onResetMessage: PropTypes.func.isRequired,
  onNextClick: PropTypes.func.isRequired,
  formValues: PropTypes.shape(),
  onBack: PropTypes.func.isRequired,
  isLoading: PropTypes.bool.isRequired,
  isLoadTwo: PropTypes.bool.isRequired,
  render: PropTypes.bool.isRequired,
  actions: PropTypes.shape().isRequired,
  getStcGuide: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.shape()),
  setValue: PropTypes.func.isRequired,
};

RslAllSetStep2.defaultProps = {
  params: undefined,
  formValues: {},
  message: [],
};

// form情報をstateで管理するためにアプリケーションで一意に名前を定義
const RslAllSetStep2Form = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
  destroyOnUnmount: false,
  forceUnregisterOnUnmount: true,
})(RslAllSetStep2);

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      cscd: state.app.reserve.consult.itemList.cscd,
      grpcd: state.app.preference.group.itemList.step2grpcd,
      cslDate: state.app.reserve.consult.itemList.cslDate,
      itemData: state.app.preference.group.itemList.itemData,
      itemLoad: state.app.preference.group.itemList.itemLoad,
      zt: state.app.preference.group.itemList.zt,
      dayIdF: state.app.reserve.consult.itemList.dayIdF,
      dayIdT: state.app.reserve.consult.itemList.dayIdT,
      allResultClear: state.app.preference.group.itemList.allResultClear,
      render: state.app.preference.group.itemList.render,
    },
    itemData: state.app.preference.group.itemList.itemData,
    errorBack: state.app.result.result.itemList.errorBack,
    nextLose: state.app.reserve.consult.itemList.nextLose,
    isLoading: state.app.reserve.consult.itemList.isLoading,
    isLoadTwo: state.app.result.result.itemList.isLoadTwo,
    render: state.app.preference.group.itemList.render,
    message: state.app.result.result.itemList.message,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch, props) => ({

  // 画面を初期化
  onLoad: (params) => {
    dispatch(getGrpItemList({ ...params }));
  },

  // デフォルト値を展開
  reLoad: (params) => {
    dispatch(getItemsandresults({ ...params }));
  },

  // ガイド画面の連絡域に検査項目コードを設定の処理
  onKeyClick: (params) => {
    dispatch(getGrpItemList({ ...params }));
  },
  // 次画面へ遷移
  onNextClick: (params, data, zt) => {
    dispatch(getUpdateResultAll({ ...params, zt, cntlNo: 0, csCd: params.cscd, type: 'next', step: 'step2', props, data: { ...data, formName, cntlNo: 0 } }));
  },
  // 表示ボタンクリック時の処理
  onSubmit: (params, data, zt) => {
    dispatch(getUpdateResultAll({ ...params, zt, cntlNo: 0, csCd: params.cscd, type: 'save', step: 'step2', props, data: { ...data, formName, cntlNo: 0 } }));
  },
  // クリア可能なエラーヒント
  onResetMessage: () => {
    dispatch(resetAllMessage());
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },

  getStcGuide: (params, itemRestList, index, zt, render) => {
    dispatch(getResetGrpItem({ ...params, itemRestList, index, zt, render }));
  },
  actions: bindActionCreators(sentenceGuideActions, dispatch),
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RslAllSetStep2Form));
