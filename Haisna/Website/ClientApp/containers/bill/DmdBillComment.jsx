import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm } from 'redux-form';
import { FieldGroup, FieldSet } from '../../components/Field';
import Button from '../../components/control/Button';
import TextArea from '../../components/control/TextArea';
import { closeDmdCommentGuide, getDmdCommentRequest } from '../../modules/bill/demandModule';
import GuideBase from '../../components/common/GuideBase';

const formName = 'DmdBillComment';
class DmdBillComment extends React.Component {
  // 登録
  handleSubmit(values) {
    const { onSubmit, billNo } = this.props;
    onSubmit(values, billNo);
  }

  render() {
    const { handleSubmit } = this.props;
    return (
      <GuideBase {...this.props} title="請求書コメント" usePagination>
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <div>
            <div>
              <Button type="submit" value="保 存" />
            </div>
            <FieldGroup>
              <FieldSet>
                コメント:<Field name="billcomment" component={TextArea} style={{ width: 500, height: 100 }} />
              </FieldSet>
            </FieldGroup>
            
          </div>
        </form>
      </GuideBase>
    );
  }
}

// propTypesの定義
DmdBillComment.propTypes = {
  billNo: PropTypes.string.isRequired,
  onSubmit: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  onClose: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  handleSubmit: PropTypes.func.isRequired,
};

// defaultPropsの定義
DmdBillComment.defaultProps = {

};
const DmdBillCommentForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(DmdBillComment);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  initialValues: {
    billcomment: state.app.bill.demand.dmdBurdenModify.billComment,
  },
  visible: state.app.bill.demand.dmdGuide.visible,
  billNo: state.app.bill.demand.dmdGuide.billNo,
});

const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeDmdCommentGuide());
  },
  onSubmit: (data, billNo) => {
    dispatch(getDmdCommentRequest({ params: billNo, data }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(DmdBillCommentForm));
