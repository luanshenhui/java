import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import { Field, reduxForm, blur } from 'redux-form';
import { FieldSet, FieldItem } from '../../components/Field';
import Button from '../../components/control/Button';
import TextArea from '../../components/control/TextArea';
import MessageBanner from '../../components/MessageBanner';
import { closePerBillGuide, updataPerBillCommentRequest } from '../../modules/bill/perBillModule';
import GuideBase from '../../components/common/GuideBase';

// カスタマイズfontラベル
const Font = styled.span`
    size: ${(props) => props.size};
    color: #${(props) => props.color};
`;
const formName = 'PerBillComment';
class PerBillComment extends React.Component {
  componentWillReceiveProps(nextProps) {
    const { visible, setValues, billcomment } = this.props;
    if (nextProps.visible && nextProps.visible !== visible) {
      setValues('billcomment', billcomment);
    }
  }
  // 保存する
  handleSubmit(values) {
    const { onSubmit, params } = this.props;
    onSubmit(values, params);
  }

  render() {
    const { handleSubmit, message } = this.props;
    return (
      <GuideBase {...this.props} title="請求書コメント" usePagination>
        <div >
          <form>
            <div>
              <div>
                <Button value="保 存" onClick={handleSubmit((values) => this.handleSubmit(values))} />
              </div>
              <Font color="FF0000"><MessageBanner messages={message} /></Font>
              <FieldSet>
                <div style={{ paddingTop: 30 }}>
                  <FieldItem>コメント</FieldItem>
                </div>
                <Field name="billcomment" component={TextArea} style={{ width: 500, height: 100 }} />
              </FieldSet>
            </div>
          </form>
        </div>
      </GuideBase>
    );
  }
}

// propTypesの定義
PerBillComment.propTypes = {
  history: PropTypes.shape().isRequired,
  visible: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  params: PropTypes.shape().isRequired,
  onSubmit: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  initialize: PropTypes.func,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  setValues: PropTypes.func.isRequired,
  billcomment: PropTypes.string,
};

// defaultPropsの定義
PerBillComment.defaultProps = {
  initialize: undefined,
  billcomment: null,
};

const PerBillCommentForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(PerBillComment);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  // 可視状態
  visible: state.app.bill.perBill.perBillGuide.visible,
  selectedItem: state.app.bill.perBill.perBillGuide.selectedItem,
  message: state.app.bill.perBill.perBillComment.message,
  billcomment: state.app.bill.perBill.perBillGuide.conditions.billcomment,
  initialValues: {
    billcomment: state.app.bill.perBill.perBillGuide.conditions.billcomment,
  },
});

const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closePerBillGuide());
  },
  onSubmit: (data, params) => {
    Object.assign(data, params);
    dispatch(updataPerBillCommentRequest({ data }));
  },
  setValues: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(PerBillCommentForm));
