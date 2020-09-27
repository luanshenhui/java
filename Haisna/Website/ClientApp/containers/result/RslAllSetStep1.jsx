import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm, getFormValues } from 'redux-form';
import moment from 'moment';
import { connect } from 'react-redux';
import SectionBar from '../../components/SectionBar';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDownSelectGrpDiv from '../../components/control/dropdown/DropDownSelectGrpDiv';
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';
import MessageBanner from '../../components/MessageBanner';
import { FieldGroup, FieldSet } from '../../components/Field';
import Label from '../../components/control/Label';
import TextBox from '../../components/control/TextBox';
import Button from '../../components/control/Button';
import { getConsultListCheckRequest, getGrpcdResult } from '../../modules/result/resultModule';
import FieldItem from '../../components/Field/FieldItem';
import { getRemoveGrpItem } from '../../modules/preference/groupModule';

const formName = 'rslAllSetForm';
class RslAllSetStep1 extends React.Component {
  constructor(props) {
    super(props);
    this.handlNextClick = this.handlNextClick.bind(this);
  }

  // コンポーネントがマウントされた直後に1回だけ呼ばれる処理
  componentDidMount() {
    const { resetLoad, onLoad, formValues } = this.props;
    resetLoad(formValues);
    onLoad();
  }

  // 次画面へ遷移
  handlNextClick() {
    const { onSubmit, formValues } = this.props;
    onSubmit(formValues);
  }

  // 描画処理
  render() {
    const { handleSubmit, nextLose, message } = this.props;
    return (
      <div>
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <FieldGroup>
            <SectionBar title="Step1：入力対象となる受診日と結果グループを選択してください。" />
            <FieldSet>
              <Field name="cslDate" component={DatePicker} id="" />
              <Label>の</Label>
              <Field name="cscd" component={DropDownCourse} addblank blankname="全てのコース" />
              <Label>当日ID</Label>
              <Field name="dayIdF" component={TextBox} id="dayIdF" maxLength="4" style={{ width: '73px' }} />
              <Label>～</Label>
              <Field name="dayIdT" component={TextBox} id="dayIdT" maxLength="4" style={{ width: '73px' }} />
            </FieldSet>
            <FieldSet>
              <FieldItem>入力結果グループ</FieldItem>
              <Field name="grpcd" component={DropDownSelectGrpDiv} grpDiv="2" />
            </FieldSet>
            <FieldSet>
              <Button onClick={this.handlNextClick} value="次 へ" />
            </FieldSet>
            <FieldSet>
              <Label>
                <MessageBanner messages={message} />
              </Label>
            </FieldSet>
            {nextLose &&
              <FieldSet>
                <Label>
                  <MessageBanner messages={['指定検査グループの検査を受診している来院済み受診者が存在しません。']} />
                </Label>
              </FieldSet>}
          </FieldGroup>
        </form>
      </div>
    );
  }
}

// propTypesの定義
RslAllSetStep1.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  nextLose: PropTypes.bool.isRequired,
  onSubmit: PropTypes.func.isRequired,
  resetLoad: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  formValues: PropTypes.shape(),
};

RslAllSetStep1.defaultProps = {
  formValues: {},
};

const RslAllSetStep1Form = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
  destroyOnUnmount: false,
  forceUnregisterOnUnmount: true,
})(RslAllSetStep1);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      cslDate: state.app.reserve.consult.itemList.cslDate ? state.app.reserve.consult.itemList.cslDate : moment().format('YYYY/MM/DD'),
      cscd: state.app.reserve.consult.itemList.cscd ? state.app.reserve.consult.itemList.cscd : '',
      grpcd: state.app.reserve.consult.itemList.grpcd ? state.app.reserve.consult.itemList.grpcd : state.app.result.result.itemList.step1grpcd,
      dayIdF: state.app.reserve.consult.itemList.dayIdF,
      dayIdT: state.app.reserve.consult.itemList.dayIdT,
      modelInfo: state.app.reserve.consult.itemList.modelInfo,
      itemData: state.app.preference.group.itemList.itemData,
      itemLoad: state.app.preference.group.itemList.itemLoad,
      allResultClear: [null],
    },
    nextLose: state.app.reserve.consult.itemList.nextLose,
    message: state.app.result.result.itemList.message,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch, props) => ({
  // 次へボタン押下時の処理
  onSubmit: (params) => {
    dispatch(getConsultListCheckRequest({ ...params, cntlNo: 0, csCd: params.cscd, step: 'step1', props }));
  },

  onLoad: () => {
    dispatch(getGrpcdResult());
  },

  resetLoad: (params) => {
    dispatch(getRemoveGrpItem({ ...params }));
  },

});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RslAllSetStep1Form));
