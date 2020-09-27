import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';
import Button from '../../components/control/Button';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import Radio from '../../components/control/Radio';
import CheckBox from '../../components/control/CheckBox';
import MessageBanner from '../../components/MessageBanner';
import { closeRptAllEntryGuide, initializeRptAllEntryGuide, cancelReceiptAllRequest, receiptAllRequest, receiptCheck } from '../../modules/reserve/consultModule';
import GuideBase from '../../components/common/GuideBase';

const formName = 'RptAllEntryGuide';

class RptAllEntryGuide extends React.Component {
  constructor(props) {
    super(props);

    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }


  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { visible, onLoad, cslDate } = this.props;
    if (nextProps.visible !== visible && !visible) {
      // onLoadアクションの引数として渡す
      onLoad({ cslDate });
    }
  }

  // 戻るボタンクリック時の処理
  handleCancelClick() {
    const { onClose } = this.props;
    onClose();
  }

  // 保存
  handleSubmit(values) {
    const { onSubmit } = this.props;

    onSubmit(values);
  }

  render() {
    const { handleSubmit, message } = this.props;


    return (
      <GuideBase {...this.props} title="一括受付" usePagination={false}>
        <div>
          <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
            <MessageBanner messages={message} />
            <div>
              <Button onClick={this.handleCancelClick} value="キャンセル" />
              <Button type="submit" value="確定" />
              <FieldGroup itemWidth={100}>
                <FieldSet>
                  <FieldItem>受診日</FieldItem>
                  <Field name="cslDate" component={DatePicker} />
                </FieldSet>
                <FieldSet>
                  <FieldItem>コース</FieldItem>
                  <Field name="csCd" component={DropDownCourse} addblank blankname="" mode={1} />
                </FieldSet>
              </FieldGroup>
              <FieldGroup itemWidth={100}>
                <FieldSet>
                  <Label>指定された受診日、コースに該当する全ての受診者に</Label>
                </FieldSet>
                <FieldSet>
                  <div style={{ paddingLeft: '25px' }} >
                    <Field component={Radio} name="mode" checkedValue={0} label="当日ＩＤを割り当てる" />
                  </div>
                </FieldSet>
                <FieldSet>
                  <div style={{ paddingLeft: '50px' }} >
                    <Field component={CheckBox} name="useEmptyId" checkedValue={0} label="空き番号が存在する場合、その番号で割り当てを行う" />
                  </div>
                </FieldSet>
                <FieldSet>
                  <div style={{ paddingLeft: '25px' }} >
                    <Field component={Radio} name="mode" checkedValue={1} label="受付を解除する" />
                  </div>
                </FieldSet>
                <FieldSet>
                  <div style={{ paddingLeft: '50px' }} >
                    <Field component={CheckBox} name="forceFlg" checkedValue={0} label="結果が入力されている場合も強制的に受付を取り消す" />
                  </div>
                </FieldSet>
              </FieldGroup>
            </div>
          </form>
        </div>
      </GuideBase>
    );
  }
}
const RptAllEntryGuideForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(RptAllEntryGuide);

// propTypesの定義
RptAllEntryGuide.propTypes = {
  visible: PropTypes.bool.isRequired,
  history: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  cslDate: PropTypes.string.isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  message: state.app.reserve.consult.rptAllEntryGuide.message,
  visible: state.app.reserve.consult.rptAllEntryGuide.visible,
  initialValues: {
    cslDate: state.app.reserve.consult.rptAllEntryGuide.cslDate,
    mode: state.app.reserve.consult.rptAllEntryGuide.mode,
  },
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeRptAllEntryGuide());
  },
  // クローズ時の処理
  onSubmit: (data) => {
    const params = {};
    let message = [];

    if (data.cslDate === null) {
      message = ['受診日を入力して下さい。'];
      dispatch(receiptCheck(message));
      return;
    }

    params.csldate = data.cslDate;
    const cntlNo = 0;
    params.csCd = data.csCd;
    if (data.csCd === 'allcourse') {
      params.csCd = '';
    }
    if (data.mode === 0) {
      let mode = 1;
      if (data.useEmptyId !== '') {
        mode = 2;
      }
      dispatch(receiptAllRequest({ ...data, mode, cntlNo }));
    } else if (data.mode === 1) {
      params.force = false;
      if (data.forceFlg === 0) {
        params.force = true;
      }
      dispatch(cancelReceiptAllRequest(params));
    }
  },
  onLoad: (params) => {
    dispatch(initializeRptAllEntryGuide(params));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RptAllEntryGuideForm));
