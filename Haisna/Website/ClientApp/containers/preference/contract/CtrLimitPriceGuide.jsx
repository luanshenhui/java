import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';

import MessageBanner from '../../../components/MessageBanner';
import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../../components/Field';
import Label from '../../../components/control/Label';
import TextBox from '../../../components/control/TextBox';
import Radio from '../../../components/control/Radio';
import Button from '../../../components/control/Button';
import DropDown from '../../../components/control/dropdown/DropDown';
import GuideBase from '../../../components/common/GuideBase';
import { getLimitPriceRequest, closeCtrLimitPriceGuide, updateLimitPriceRequest, deleteLimitPriceRequest } from '../../../modules/preference/contractModule';

const formName = 'ctrLimitPriceGuideForm';

class CtrLimitPriceGuide extends React.Component {
  constructor(props) {
    super(props);

    this.handleRemoveClick = this.handleRemoveClick.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { visible, onLoad } = this.props;
    if (!visible && nextProps.visible !== visible) {
      // onLoadアクションの引数として渡す
      onLoad(nextProps);
    }
  }

  // コンポーネントがアンマウントされる場合の処理
  componentWillUnmount() {
    // フォーム入力内容の初期化
    this.props.reset();
  }

  // 限度額の設定
  handleSubmit(values) {
    const { onSubmit } = this.props;
    // onSubmitアクションの引数として渡す
    onSubmit(this.props, values);
  }

  // 限度額の削除
  handleRemoveClick(values) {
    const { onDelete } = this.props;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この限度額情報を削除します。よろしいですか？')) {
      return;
    }
    onDelete(this.props, values);
  }

  render() {
    const { handleSubmit, message, onClose, orgSNameItems } = this.props;

    return (
      <GuideBase {...this.props} title="限度額の設定" usePagination={false}>
        <MessageBanner messages={message} />
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <div>
            <Button onClick={onClose} value="キャンセル" />
            <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />
            <Button onClick={handleSubmit((values) => this.handleRemoveClick(values))} value="削除" />
          </div>
          <div>
            <FieldGroup itemWidth={180}>
              <FieldSet>
                <FieldItem>対象負担元</FieldItem>
                <Field name="seqorg" component={DropDown} items={orgSNameItems} addblank id="seqorg" />
              </FieldSet>
              <FieldSet>
                <FieldItem>限度額</FieldItem>
                <FieldValueList>
                  <FieldValue>
                    <Label>総金額に対する限度率</Label>
                    <Field name="limitrate" component={TextBox} id="limitrate" maxLength="3" style={{ width: 85, textAlign: 'right' }} />
                    <Label>％</Label>
                  </FieldValue>
                  <FieldValue>
                    <Label>総金額：</Label>
                    <Field name="limittaxflg" component={Radio} checkedValue={1} label="消費税を含む" />
                    <Field name="limittaxflg" component={Radio} checkedValue={0} label="消費税を含まない" />
                  </FieldValue>
                </FieldValueList>
              </FieldSet>
              <FieldSet>
                <FieldItem>上限金額</FieldItem>
                <Field name="limitprice" component={TextBox} id="limitprice" maxLength="7" style={{ width: 85, textAlign: 'right' }} />
                <Label>円</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>減算した金額の負担元</FieldItem>
                <Field name="seqbdnorg" component={DropDown} items={orgSNameItems} addblank id="seqbdnorg" />
              </FieldSet>
            </FieldGroup>
          </div>
        </form>
      </GuideBase>
    );
  }
}

const CtrLimitPriceGuideForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(CtrLimitPriceGuide);

CtrLimitPriceGuide.propTypes = {
  visible: PropTypes.bool.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  orgSNameItems: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  reset: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  message: state.app.preference.contract.ctrLimitPriceGuide.message,
  visible: state.app.preference.contract.ctrLimitPriceGuide.visible,
  bdnItems: state.app.preference.contract.ctrLimitPriceGuide.bdnItems,
  orgSNameItems: state.app.preference.contract.ctrLimitPriceGuide.orgSNameItems,
  initialValues: {
    seqorg: state.app.preference.contract.ctrLimitPriceGuide.seqOrg,
    seqbdnorg: state.app.preference.contract.ctrLimitPriceGuide.seqBdnOrg,
    limitrate: state.app.preference.contract.ctrLimitPriceGuide.ctrPtdata.limitrate,
    limittaxflg: state.app.preference.contract.ctrLimitPriceGuide.ctrPtdata.limittaxflg,
    limitprice: state.app.preference.contract.ctrLimitPriceGuide.ctrPtdata.limitprice,
  },
});

const mapDispatchToProps = (dispatch) => ({

  onLoad: (params) => {
    // 画面を初期化
    // 契約パターン情報の読み込み
    // 負担元および限度額負担フラグの読み込み(団体)
    dispatch(getLimitPriceRequest({ ctrptcd: params.ctrptcd, orgcd1: params.orgcd1, orgcd2: params.orgcd2 }));
  },
  onSubmit: (params, data) => {
    // 限度額情報更新
    dispatch(updateLimitPriceRequest({ params, data }));
  },
  onDelete: (params, data) => {
    // 限度額情報削除
    dispatch(deleteLimitPriceRequest({ params, data }));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeCtrLimitPriceGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(CtrLimitPriceGuideForm);
