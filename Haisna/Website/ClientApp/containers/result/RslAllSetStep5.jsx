import React from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import moment from 'moment';
import { withRouter } from 'react-router-dom';
import { reduxForm, getFormValues, blur } from 'redux-form';
import { connect } from 'react-redux';
import SectionBar from '../../components/SectionBar';
import MessageBanner from '../../components/MessageBanner';
import { getRslAllSetListRequest, getCheckResultThenSave, getResetRstItem } from '../../modules/result/resultModule';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import TextBox from '../../components/control/TextBox';
import Button from '../../components/control/Button';
import GuideButton from '../../components/GuideButton';
import LabelGrpDiv from '../../components/control/label/LabelGrpDiv';
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


class RslAllSetStep5 extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleResultChange = this.handleResultChange.bind(this);
  }

  // コンポーネントがマウントされた直後に1回だけ呼ばれる処理
  componentDidMount() {
    const { formValues, onLoad } = this.props;
    onLoad(formValues);
  }

  // 表示ボタンクリック時の処理
  handleSubmit() {
    const { formValues, onSubmit } = this.props;
    onSubmit(formValues);
  }


  // 検査結果の編集
  handleResultChange(event, num, index) {
    const { target } = event;
    const { setValue } = this.props;
    setValue(`saveItemData.saveItemData[${num}].infoResult[${index}].result`, target.value);
  }

  // 描画処理
  render() {
    const { handleSubmit, formValues, message, actions, getStepGuide, stepRender, isLoadTwo } = this.props;
    return (
      <div>
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <FieldGroup>
            <SectionBar title="Step5：例外者の結果入力" />
            <FieldSet>
              <FieldItem><nobr>受診日</nobr></FieldItem>
              <Label name=""><nobr><span style={{ color: '#ff6600' }}><b>{formValues.cslDate}</b></span></nobr></Label>
              <Label />
              <FieldItem><nobr>入力用検査項目セット</nobr></FieldItem>
              <Label name=""><LabelGrpDiv grpcd={formValues.grpcd} grpDiv="2" style={{ color: '#ff6600' }} /></Label>
              <Button type="submit" value="保存" />
            </FieldSet>
            <FieldSet>
              <Label>
                {message && message.length > 0 && <MessageBanner messages={message} />}
              </Label>
            </FieldSet>
          </FieldGroup>
          {formValues.saveItemData && formValues.saveItemData.saveItemData && formValues.saveItemData.saveItemData.map((person, num) => (
            <table style={{ width: '100%' }} key={`${person.info.dayid}-${person.info.rsvno}`}>
              <thead>
                <tr>
                  <th style={{ width: '10%', textAlign: 'left', backgroundColor: '#ccc' }}>当日ＩＤ</th>
                  <th style={{ width: '24%', textAlign: 'left', backgroundColor: '#ccc' }}>氏名</th>
                  <th style={{ width: '14%', textAlign: 'right', backgroundColor: '#ccc' }}>検査項目名</th>
                  <th style={{ width: '10%', textAlign: 'left', backgroundColor: '#ccc' }} colSpan="2">部位</th>
                  <th style={{ width: '14%', textAlign: 'left', backgroundColor: '#ccc' }} colSpan="2">所見</th>
                  <th style={{ width: '14%', textAlign: 'left', backgroundColor: '#ccc' }}>部位文章</th>
                  <th style={{ width: '14%', textAlign: 'left', backgroundColor: '#ccc' }}>所見文章</th>
                </tr>
              </thead>
              <tbody>
                {person.infoResult && person.infoResult.map((rec, index) => (
                  <tr key={`${rec.itemname}`}>
                    {index === 0 && <td>{person.info.dayid.toString().length === 4 ? '' : 0 }{person.info.dayid}</td>}
                    {index === 0 && <td>{person.info.perid}&nbsp;&nbsp;&nbsp;<span><b>{person.info.lastname}&nbsp;&nbsp;&nbsp;{person.info.firstname}</b></span></td>}
                    {index === 1 && <td />}
                    {index === 1 &&
                      <td><div style={{ width: '8px' }} />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        {person.info.birthyearshorteraname}
                        {person.info.birtherayear}&nbsp;&nbsp;
                        {moment(person.info.birth).format('MM.DD')}生&nbsp;&nbsp;
                        {person.info.age}歳&nbsp;&nbsp;{person.info.gender === 1 ? '男性' : '女性'}
                      </td>}
                    {index === 2 && <td />}
                    {index === 2 && <td>受診コース：<span style={{ color: '#ff6600' }}>{person.info.csname}</span></td>}
                    {index !== 0 && index !== 1 && index !== 2 && <td />}
                    {index !== 0 && index !== 1 && index !== 2 && <td />}
                    <td style={{ width: '14%' }} align="right">{rec.itemname}</td>
                    <td>
                      {(rec.resulttype === 1 || rec.resulttype === 2 || rec.resulttype === 4) && rec.itemtype !== 0 && rec.consultflg === 1 && rec.resulttype !== 5 &&
                        <GuideButton
                          onClick={() => actions.sentenceGuideOpenRequest({
                            itemCd: rec.itemcd,
                            itemType: rec.itemtype,
                          onConfirm: (itemgrpdata) => getStepGuide(itemgrpdata, formValues.saveItemData, index, stepRender, num),
                          })}
                        />}
                    </td>
                    <td>
                      {rec.resulttype === 5 && rec.itemtype !== 0 && <span style={{ color: '#ff6600' }}>{rec.result}</span>}
                      {rec.itemtype !== 0 && rec.consultflg === 1 && rec.resulttype !== 5 && <input
                        type="text"
                        value={rec.result}
                        name={`saveItemData.saveItemData[${num}].infoResult[${index}].result`}
                        component={TextBox}
                        maxLength="8"
                        style={{ backgroundColor: backColor(rec.resulterror), color: showColor(rec.stdflg), width: '92px', textAlign: rightAs(rec.resulttype) }}
                        onChange={(event) => this.handleResultChange(event, num, index)}
                      />}
                    </td>
                    <td>
                      {(rec.resulttype === 1 || rec.resulttype === 2 || rec.resulttype === 4) && rec.itemtype === 0 && rec.consultflg === 1 && rec.resulttype !== 5 &&
                        <GuideButton
                          onClick={() => actions.sentenceGuideOpenRequest({
                            itemCd: rec.itemcd,
                            itemType: rec.itemtype,
                          onConfirm: (itemgrpdata) => getStepGuide(itemgrpdata, formValues.saveItemData, index, stepRender, num),
                          })}
                        />}
                    </td>
                    <td>
                      {rec.resulttype === 5 && rec.itemtype === 0 && <span style={{ color: '#ff6600' }}>{rec.result}</span>}
                      {rec.itemtype === 0 && rec.consultflg === 1 && rec.resulttype !== 5 && <input
                        type="text"
                        value={rec.result}
                        name={`saveItemData.saveItemData[${num}].infoResult[${index}].result`}
                        component={TextBox}
                        maxLength="8"
                        style={{ backgroundColor: backColor(rec.resulterror), color: showColor(rec.stdflg), width: '92px', textAlign: rightAs(rec.resulttype) }}
                        onChange={(event) => this.handleResultChange(event, num, index)}
                      />}
                    </td>
                    <td>{rec.itemtype !== 0 && <span>{rec.shortstc}</span>}</td>
                    <td>{rec.itemtype === 0 && <span>{rec.shortstc}</span>}</td>
                  </tr>
                ))}
                {person.infoResult && person.infoResult.length === 1 && <tr><td />
                  <td><div style={{ width: '8px' }} />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    {person.info.birthyearshorteraname}
                    {person.info.birtherayear}&nbsp;&nbsp;
                    {moment(person.info.birth).format('MM.DD')}生&nbsp;&nbsp;
                    {person.info.age}歳&nbsp;&nbsp;{person.info.gender === 1 ? '男性' : '女性'}
                  </td> <td /> <td /> <td /> <td /> <td /> <td /> <td /></tr>}
                {person.infoResult &&
                  person.infoResult.length < 3 && <tr><td /><td>受診コース：<span style={{ color: '#ff6600' }}>{person.info.csname}</span></td><td /><td /><td /><td /><td /><td /><td /></tr>}
              </tbody>
            </table>
            ))}
        </form>
        {isLoadTwo && <CircularProgress />}
      </div>
    );
  }
}

// propTypesの定義
RslAllSetStep5.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  formValues: PropTypes.shape().isRequired,
  onSubmit: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.shape()),
  stepRender: PropTypes.bool.isRequired,
  actions: PropTypes.shape().isRequired,
  getStepGuide: PropTypes.func.isRequired,
  isLoadTwo: PropTypes.bool.isRequired,
  setValue: PropTypes.func.isRequired,
};

RslAllSetStep5.defaultProps = {
  message: [],
};

const RslAllSetStep5Form = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
  destroyOnUnmount: false,
  forceUnregisterOnUnmount: true,
})(RslAllSetStep5);

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      grpcd: formValues.grpcd,
      cslDate: formValues.cslDate,
      saveItemData: state.app.result.result.itemList.saveItemData,
    },
    message: state.app.result.result.itemList.message,
    stepRender: state.app.result.result.itemList.stepRender,
    isLoadTwo: state.app.result.result.itemList.isLoadTwo,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // 画面を初期化
  onLoad: (params) => {
    dispatch(getRslAllSetListRequest({ ...params }));
  },
  // 表示ボタンクリック時の処理
  onSubmit: (formValues) => {
    dispatch(getCheckResultThenSave({ ...formValues }));
  },

  getStepGuide: (params, itemRestList, index, stepRender, num) => {
    dispatch(getResetRstItem({ ...params, itemRestList, index, stepRender, num }));
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },

  actions: bindActionCreators(sentenceGuideActions, dispatch),
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RslAllSetStep5Form));
