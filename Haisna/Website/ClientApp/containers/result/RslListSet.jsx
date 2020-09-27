import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import moment from 'moment';
import { Field, reduxForm, getFormValues, blur } from 'redux-form';
import { withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import PageLayout from '../../layouts/PageLayout';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDown from '../../components/control/dropdown/DropDown';
import MessageBanner from '../../components/MessageBanner';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import TextBox from '../../components/control/TextBox';
import Button from '../../components/control/Button';
import Table from '../../components/Table';
import DropDownSelectGrpDiv from '../../components/control/dropdown/DropDownSelectGrpDiv';
import { getConsultSetList, updateRslListSet, getRslListSetList, getDestroySetList } from '../../modules/result/resultModule';
import CircularProgress from '../../components/control/CircularProgress/CircularProgress';

const RsTable = Table.extend`
  border-top: 1px solid #ccc;
  width:auto;
`;

const RsTd = styled.td`
  border-left: 1px solid #ccc;
  border-right: 1px solid #ccc;
`;
const RsTh = styled.th`
  border-left: 1px solid #ccc;
  border-right: 1px solid #ccc;
  white-space: normal !important;
`;


// 初期データ
const delflgItems2 = [{ value: '', name: '当日ID順' },
  { value: '3', name: '個人ＩＤ順' }];

const delflgItems3 = [{ value: '10', name: '10件ずつ' },
  { value: '20', name: '20件ずつ' },
  { value: '50', name: '50件ずつ' },
  { value: '1', name: '全部' }];

const formName = 'rslListSetForm';

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
  if (stdflg !== 3 && stdflg !== 4 && stdflg !== 5 && stdflg !== 8) {
    loaction = 'right';
  }
  return loaction;
};

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

let paramstro = null;

class RslListSet extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleKeyClick = this.handleKeyClick.bind(this);
    this.handlePrevClick = this.handlePrevClick.bind(this);
    this.handleNextClick = this.handleNextClick.bind(this);
    this.handleResultBlur = this.handleResultBlur.bind(this);
  }

  // コンポーネントがマウントされた直後に1回だけ呼ばれる処理
  componentDidMount() {
    const { formValues, onLoad } = this.props;
    onLoad(formValues);
  }

  componentWillUnmount() {
    const { onDestroy } = this.props;
    onDestroy();
  }


  // 表示ボタンクリック時の処理
  handleSubmit(values) {
    const { onSubmit } = this.props;
    onSubmit(values);
  }

  // ガイド画面の連絡域に検査項目コードを設定の処理
  handleKeyClick() {
    const { onKeyClick, formValues, setValue } = this.props;
    const params = {};
    params.grpcd = formValues.grpcd;
    params.cslDate = formValues.cslDate;
    params.dayIdF = formValues.dayIdF;
    params.getCount = formValues.getCount;
    params.sortKey = formValues.sortKey;
    paramstro = params;
    params.flagBoo = formValues.flagBoo;
    setValue('resultData', []);
    if (formValues.resultData.length > 0) {
      params.isData = true;
    } else {
      params.isData = false;
    }
    params.isKey = true;
    onKeyClick(params);
  }

  // 前の受診者を表示
  handlePrevClick() {
    const { onKeyClick, formValues } = this.props;
    if (paramstro === null) {
      const params = {};
      params.grpcd = formValues.grpcd;
      params.cslDate = formValues.cslDate;
      params.dayIdF = formValues.dayIdF;
      params.getCount = formValues.getCount;
      params.sortKey = formValues.sortKey;
      params.page = formValues.page > 0 ? formValues.page - 1 : formValues.page;
      onKeyClick(params);
    } else {
      paramstro.page = formValues.page > 0 ? formValues.page - 1 : formValues.page;
      paramstro.isKey = false;
      paramstro.isData = true;
      onKeyClick(paramstro);
    }
  }
  // 次の受診者を表示
  handleNextClick() {
    const { onKeyClick, formValues } = this.props;
    if (paramstro === null) {
      const params = {};
      params.grpcd = formValues.grpcd;
      params.cslDate = formValues.cslDate;
      params.dayIdF = formValues.dayIdF;
      params.getCount = formValues.getCount;
      params.sortKey = formValues.sortKey;
      params.page = formValues.page + 1;
      onKeyClick(params);
    } else {
      paramstro.page = formValues.page + 1;
      paramstro.isKey = false;
      paramstro.isData = true;
      onKeyClick(paramstro);
    }
  }

  // 検査結果の編集
  handleResultBlur(event, num, index) {
    const { target } = event;
    const { setValue } = this.props;
    setValue(`resultData.[${num}].result[${index}].result`, target.value);
  }

  // 描画処理
  render() {
    const { handleSubmit, formValues, newDate, listErr, message, isLoading } = this.props;
    return (
      <PageLayout title="ワークシート形式の結果入力">
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <div className="contents frame_content">
            <FieldGroup>
              <FieldSet>
                <FieldItem>受診日</FieldItem>
                <Field name="cslDate" component={DatePicker} id="cslDate" />
              </FieldSet>
              <FieldSet>
                <Field name="grpcd" component={DropDownSelectGrpDiv} id="grpcd" grpDiv="2" />
                <Label>の結果を</Label>
                <Field name="sortKey" component={DropDown} items={delflgItems2} id="sortKey" />
                <Label>番号</Label>
                <Field name="dayIdF" component={TextBox} id="dayIdF" maxLength="4" style={{ width: 90 }} />
                <Label>から</Label>
                <Field name="getCount" component={DropDown} items={delflgItems3} id="getCount" />
              </FieldSet>
              <FieldSet>
                <Button onClick={this.handleKeyClick} value="表示" />
                {formValues.resultData && formValues.resultData.length > 0 && <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保 存" />}
              </FieldSet>
              {formValues.resultData && formValues.resultData.length > 0 &&
                <FieldSet >
                  <Label>「<span style={{ color: '#ff6600' }} ><b>{newDate}日</b></span>」の来院済み受診者一覧を表示しています。対象者数は<span style={{ color: '#ff6600' }} ><b>{formValues.count}</b></span>人です。</Label>
                </FieldSet>}
              <FieldSet>
                <Label>
                  {!listErr && message && message.length > 0 && <MessageBanner messages={message} />}
                </Label>
              </FieldSet>
              {listErr &&
                <FieldSet>
                  <Label>
                    <MessageBanner messages={['条件に合致する受診情報は存在しません。']} />
                  </Label>
                </FieldSet>}
            </FieldGroup>
            <RsTable striped hover>
              {formValues.title && formValues.title.length > 0 && formValues.resultData && formValues.resultData.length > 0 &&
                <thead>
                  <tr>
                    <RsTh style={{ width: 50 }}><div style={{ width: 50 }}>当日ID</div></RsTh>
                    <RsTh style={{ width: 50 }}><div style={{ width: 76 }}>個人ID</div></RsTh>
                    <RsTh style={{ width: 170 }}>氏名</RsTh>
                    {formValues.title && formValues.title.map((res, index) => (
                      <RsTh key={`${res.itemcd}-${res.itemname}-${res.stcitemcd}-${index.toString()}`}><div style={{ minWidth: '83px' }}>{res.itemname}</div></RsTh>
                    ))}
                  </tr>
                </thead>}
              <tbody>
                {formValues.resultData && formValues.resultData.map((rec, num) => (
                  <tr key={`${rec.dayid}-${rec.rsvno}-${rec.perid}`}>
                    <RsTd style={{ width: 50 }}>{rec.dayid.toString().length === 3 ? 0 : ''}{rec.dayid}</RsTd>
                    <RsTd style={{ width: 50 }}>{rec.perid}</RsTd>
                    <RsTd style={{ whiteSpace: 'nowrap' }}>{rec.lastname}&nbsp;&nbsp;&nbsp;{rec.firstname}</RsTd>
                    {rec.result && rec.result.map((rs, index) => (
                      <RsTd key={`${rs.itemcd}-${rs.itemname}-${index.toString()}-${num.toString()}`}>
                        {rs.resulttype !== 5 && rs.consultflg === 1 && <input
                          type="text"
                          value={formValues.resultData[num].result[index].result}
                          name={`resultData.[${num}].result[${index}].result`}
                          maxLength="8"
                          size="8"
                          style={{ width: '100%', backgroundColor: backColor(rs.resulterror), textAlign: rightAs(rs.resulttype), color: showColor(rs.stdflg) }}
                          onChange={(event) => this.handleResultBlur(event, num, index)}
                        />}
                        {rs.resulttype === 5 &&
                          <span style={{ textAlign: rightAs(rs.resulttype), color: showColor(rs.stdflg) }}><div style={{ width: '83px' }}>{rs.result}</div></span>
                        }
                      </RsTd>
                     ))}
                  </tr>
                ))}
              </tbody>
            </RsTable>
            <FieldGroup>
              <FieldSet>
                {!listErr && formValues.page !== 0 && formValues.page > 1 && <Button onClick={this.handlePrevClick} value="前受診者" />}
                {formValues.cruPage < formValues.count && formValues.cruPage !== 0 && formValues.resultData.length !== 0 && <Button onClick={this.handleNextClick} value="次受診者" />}
              </FieldSet>
            </FieldGroup>
          </div>
        </form>
        {isLoading && <CircularProgress />}
      </PageLayout>
    );
  }
}

// propTypesの定義
RslListSet.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onKeyClick: PropTypes.func.isRequired,
  formValues: PropTypes.shape(),
  isLoading: PropTypes.bool.isRequired,
  newDate: PropTypes.string,
  listErr: PropTypes.bool.isRequired,
  message: PropTypes.arrayOf(PropTypes.shape()),
  onLoad: PropTypes.func.isRequired,
  onDestroy: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
};

RslListSet.defaultProps = {
  message: [],
  formValues: {},
  newDate: moment().format('YYYY/MM/DD'),
};

const RslListSetForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(RslListSet);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      cslDate: state.app.result.result.rslListSet.cslDate ? state.app.result.result.rslListSet.cslDate : moment().format('YYYY/MM/DD'),
      grpcd: state.app.result.result.rslListSet.grpcd ? state.app.result.result.rslListSet.grpcd : 'G010',
      dayIdF: state.app.result.result.rslListSet.dayIdF ? state.app.result.result.rslListSet.dayIdF : '',
      getCount: state.app.result.result.rslListSet.getCount ? state.app.result.result.rslListSet.getCount : '20',
      sortKey: state.app.result.result.rslListSet.sortKey ? state.app.result.result.rslListSet.sortKey : '',
      resultData: state.app.result.result.rslListSet.resultData,
      count: state.app.result.result.rslListSet.count,
      page: state.app.result.result.rslListSet.page,
      cruPage: state.app.result.result.rslListSet.cruPage,
      title: state.app.result.result.rslListSet.title,
      flagBoo: state.app.result.result.rslListSet.flagBoo,
    },
    newDate: state.app.result.result.rslListSet.newDate,
    listErr: state.app.result.result.rslListSet.listErr,
    message: state.app.result.result.rslListSet.message,
    isLoading: state.app.result.result.rslListSet.isLoading,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // 画面を初期化
  onLoad: (params) => {
    dispatch(getRslListSetList({ ...params }));
  },
  // 部品を廃棄する
  onDestroy: () => {
    dispatch(getDestroySetList());
  },

  // ガイド画面の連絡域に検査項目コードを設定の処理
  onKeyClick: (params) => {
    dispatch(getConsultSetList({ ...params }));
  },

  onSubmit: (params) => {
    dispatch(updateRslListSet({ ...params }));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RslListSetForm));
