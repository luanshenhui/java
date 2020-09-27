import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import { Field, reduxForm, getFormValues, blur } from 'redux-form';
import SectionBar from '../../components/SectionBar';
import CheckBox from '../../components/control/CheckBox';
import { FieldGroup, FieldSet } from '../../components/Field';
import BulletedLabel from '../../components/control/BulletedLabel';
import { getUpdateResultAll } from '../../modules/result/resultModule';
import Button from '../../components/control/Button';
import Table from '../../components/Table';
import { getConsultListItemRequest } from '../../modules/reserve/consultModule';
import CircularProgress from '../../components/control/CircularProgress/CircularProgress';

const formName = 'rslAllSetForm';


const WrapperBrowseCopy = styled.div`
  .bullet { color: #cc9999 };
`;

const OptionLine = (e) => {
  const trs = [];
  let tds = [];
  // 4行分編集
  if (e.modelInfoThree && e.modelInfoThree.length > 0) {
    const arr = e.modelInfoThree;
    for (let i = 0; i < arr.length; i += 1) {
      const { lastname, dayid, firstname } = arr[i];
      let dId = dayid;
      if (dayid.toString().length === 3) {
        dId = `0${dayid}`;
      } else {
        dId = dayid;
      }
      tds.push(<td width="25%"><input type="checkbox" component={CheckBox} onClick={(event) => e.handleKey(event, i)} /> {dId} {lastname} {firstname} </td>);
      if ((i + 1) % 4 === 0) {
        trs.push(<tr>{tds}</tr>);
        tds = [];
      } else if ((i + 1) === arr.length) {
        trs.push(<tr>{tds}</tr>);
      }
    }
  }
  return trs;
};


class RslAllSetStep3 extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handlBackClick = this.handlBackClick.bind(this);
    this.handleKey = this.handleKey.bind(this);
  }

  // コンポーネントがマウントされた直後に1回だけ呼ばれる処理
  componentDidMount() {
    const { onLoad, formValues } = this.props;
    if (formValues.allResultClear && formValues.allResultClear[0] === 1) {
      formValues.allResultClear = 1;
    } else {
      formValues.allResultClear = 0;
    }
    onLoad(formValues);
  }

  // 「戻る」ボタンクリック時の処理
  handlBackClick() {
    const { onBack } = this.props;
    onBack();
  }

  // 表示ボタンクリック時の処理
  handleSubmit(values) {
    const { match, onSubmit, formValues } = this.props;
    onSubmit(match.params, values, formValues.modelInfoThree, formValues.itemData, formValues.zt);
  }

  // 検査結果の編集
  handleKey(event, i) {
    const { target } = event;
    const { setValue } = this.props;
    setValue(`modelInfoThree[${i}].result`, target.checked === true ? '1' : null);
  }

  // 描画処理
  render() {
    const { handleSubmit, isLoading, formValues } = this.props;
    return (
      <div>
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))} >
          <FieldGroup>
            <SectionBar title="Step3：例外者の選択" />
            <FieldSet>
              <WrapperBrowseCopy>
                <BulletedLabel>この一括結果入力処理で、検査結果をセットしたくない受診者を選択してください。</BulletedLabel>
              </WrapperBrowseCopy>
            </FieldSet>
            {formValues.allResultClear && formValues.allResultClear[0] === null &&
              <FieldSet>
                <Field component={CheckBox} name={`allResultClear.${0}`} checkedValue={1} label="すでに入力されている結果を上書きする" id="" />
              </FieldSet>}
            <FieldSet>
              <Button onClick={this.handlBackClick} value="戻 る" />
              <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保 存" />
            </FieldSet>
          </FieldGroup>
          <Table striped hover style={{ width: 1000 }}>
            <thead>
              {formValues.modelInfoThree && formValues.modelInfoThree.length === 1 &&
                <tr>
                  <th width="25%">当日ＩＤ      氏名</th>
                  <th width="25%" style={{ borderBottom: '0px solid' }} />
                  <th width="25%" style={{ borderBottom: '0px solid' }} />
                  <th width="25%" style={{ borderBottom: '0px solid' }} />
                </tr>
              }
              {formValues.modelInfoThree && formValues.modelInfoThree.length === 2 &&
                <tr>
                  <th width="25%">当日ＩＤ      氏名</th>
                  <th width="25%">当日ＩＤ      氏名</th>
                  <th width="25%" style={{ borderBottom: '0px solid' }} />
                  <th width="25%" style={{ borderBottom: '0px solid' }} />
                </tr>
              }
              {formValues.modelInfoThree && formValues.modelInfoThree.length === 3 &&
                <tr>
                  <th width="25%">当日ＩＤ      氏名</th>
                  <th width="25%">当日ＩＤ      氏名</th>
                  <th width="25%">当日ＩＤ      氏名</th>
                  <th width="25%" style={{ borderBottom: '0px solid' }} />
                </tr>
              }
              {formValues.modelInfoThree && formValues.modelInfoThree.length >= 4 &&
                <tr>
                  <th width="25%">当日ＩＤ      氏名</th>
                  <th width="25%">当日ＩＤ      氏名</th>
                  <th width="25%">当日ＩＤ      氏名</th>
                  <th width="25%">当日ＩＤ      氏名</th>
                </tr>
              }
            </thead>
            {isLoading && <CircularProgress />}
            <tbody>
              {formValues.modelInfoThree && <OptionLine modelInfoThree={formValues.modelInfoThree} handleKey={this.handleKey} /> }
            </tbody>
          </Table>
        </form>
      </div>
    );
  }
}

// propTypesの定義
RslAllSetStep3.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  formValues: PropTypes.shape().isRequired,
  onSubmit: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  onBack: PropTypes.func.isRequired,
  isLoading: PropTypes.bool.isRequired,
  setValue: PropTypes.func.isRequired,
};


const RslAllSetStep3Form = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
  destroyOnUnmount: false,
  forceUnregisterOnUnmount: true,
})(RslAllSetStep3);

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      modelInfoThree: state.app.reserve.consult.itemList.modelInfo,
      itemData: state.app.preference.group.itemList.itemData,
      selectPerson: state.app.result.result.itemList.selectPerson,
      grpcd: state.app.reserve.consult.itemList.grpcd,
      cslDate: state.app.reserve.consult.itemList.cslDate,
      zt: state.app.preference.group.itemList.zt,
      dayIdF: state.app.reserve.consult.itemList.dayIdF,
      dayIdT: state.app.reserve.consult.itemList.dayIdT,
      allResultClear: state.app.reserve.consult.itemList.allResultClear,
    },
    isLoading: state.app.reserve.consult.itemList.isLoading,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch, props) => ({
  // 画面を初期化
  onLoad: (params) => {
    dispatch(getConsultListItemRequest({ ...params, cntlNo: 0, csCd: params.cscd, grpCd: params.grpcd, step: 'step3' }));
  },
  // 表示ボタンクリック時の処理
  onSubmit: (params, data, modelInfoThree, itemData, zt) => {
    const { cscd, grpcd, cslDate } = params;
    dispatch(getUpdateResultAll({ ...params, zt, cntlNo: 0, csCd: params.cscd, step: 'step3', props, data: { ...data, formName, cntlNo: 0, cscd, grpcd, cslDate, modelInfoThree, itemData } }));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RslAllSetStep3Form));
