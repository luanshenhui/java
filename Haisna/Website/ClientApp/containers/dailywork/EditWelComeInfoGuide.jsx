import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Field, reduxForm } from 'redux-form';

import { FieldGroup, FieldSet, FieldItem, FieldValue } from '../../components/Field';
import Button from '../../components/control/Button';
import Radio from '../../components/control/Radio';
import TextBox from '../../components/control/TextBox';
import CheckBox from '../../components/control/CheckBox';
import MessageBanner from '../../components/MessageBanner';

import { updateWelComeInfoRequest, closeEditWelComeInfoGuide } from '../../modules/reserve/consultModule';

const formName = 'EditWelComeInfoGuide';

class EditWelComeInfoGuide extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // 保存処理
  handleSubmit(values) {
    const { welcomeflag } = this.props;

    // 来院情報を来院→未来院にしたときは確認メッセージを表示
    if (this.props.mode === 2) {
      if (values.welcomeflag === 2 && welcomeflag === 1) {
        // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
        // eslint-disable-next-line no-alert,no-restricted-globals
        if (!confirm('未来院にします。よろしいですか？')) {
          return;
        }
      }
    }
    const { onSubmit, mode } = this.props;
    const { data } = this.props;
    const { rsvno } = data;
    const { dayid, ocrno, lockerkey, force } = values;
    // onSubmitアクションの引数として渡す
    const params = { rsvno, mode, dayid, welcome: values.welcomeflag, ocrno, lockerkey, force };
    // 保存処理を行う
    onSubmit(params);
  }

  render() {
    const { mode, message, handleSubmit, visitstatus, visiterror, onClose } = this.props;
    const title = () => {
      switch (mode) {
        case 1:
          return '当日ID';
        case 2:
          return '来院';
        case 3:
          return 'OCR番号';
        case 4:
          return 'ロッカーキー';
        default:
          return '';
      }
    };
    return (
      <div>
        <MessageBanner messages={message} />
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <div>
            <FieldGroup itemWidth={100}>
              <FieldSet>
                <FieldValue>
                  <Button type="submit" onClick={onClose} value="キャンセル" />
                  <Button type="submit" value="保 存" />
                </FieldValue>
              </FieldSet>
              <FieldValue>
                <FieldSet>
                  <FieldItem>{title()}</FieldItem>
                  <FieldValue>
                    {(mode === 1) &&
                      <Field name="dayid" component={TextBox} id="dayid" maxLength="4" autoFocus="true" style={{ imeMode: 'disabled', width: 55 }} />
                    }
                    {(mode === 2) &&
                      <div>
                        <Field name="welcomeflag" component={Radio} checkedValue={1} label="来院" />
                        <Field name="welcomeflag" component={Radio} checkedValue={2} label="未来院" />
                      </div>
                    }
                    {(mode === 2 && visiterror === true && visitstatus === -1) &&
                      <FieldValue>
                        <Field component={CheckBox} name="force" checkedValue={1} label="強制的に未来院処理を行う" />
                      </FieldValue>
                    }
                    {(mode === 3) &&
                      <Field name="ocrno" component={TextBox} id="ocrno" maxLength="10" autoFocus="true" style={{ imeMode: 'disabled', width: 138 }} />
                    }
                    {(mode === 4) &&
                      <Field name="lockerkey" component={TextBox} id="lockerkey" maxLength="5" autoFocus="true" style={{ imeMode: 'disabled', width: 70 }} />
                    }
                  </FieldValue>
                </FieldSet>
              </FieldValue>
            </FieldGroup>
          </div>
        </form>
      </div>
    );
  }
}

// propTypesの定義
EditWelComeInfoGuide.propTypes = {
  onClose: PropTypes.func.isRequired,
  mode: PropTypes.number.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onSubmit: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  visitstatus: PropTypes.number.isRequired,
  visiterror: PropTypes.bool.isRequired,
  welcomeflag: PropTypes.number.isRequired,
  data: PropTypes.shape().isRequired,
};

const EditWelComeInfoForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(EditWelComeInfoGuide);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  visible: state.app.reserve.consult.editWelComeInfoGuide.visible,
  mode: state.app.reserve.consult.editWelComeInfoGuide.mode,
  message: state.app.reserve.consult.editWelComeInfoGuide.message,
  visitstatus: state.app.reserve.consult.editWelComeInfoGuide.visitstatus,
  visiterror: state.app.reserve.consult.editWelComeInfoGuide.visiterror,
  data: state.app.reserve.consult.editWelComeInfoGuide.data,
  welcomeflag: state.app.reserve.consult.editWelComeInfoGuide.welcomeflag,
  initialValues: {
    welcomeflag: state.app.reserve.consult.editWelComeInfoGuide.welcomeflag,
    dayid: state.app.reserve.consult.editWelComeInfoGuide.data.dayid,
    orcno: state.app.reserve.consult.editWelComeInfoGuide.data.orcno,
    lockerkey: state.app.reserve.consult.editWelComeInfoGuide.data.lockerkey,
  },
});

const mapDispatchToProps = (dispatch) => ({
  // 更新時の処理
  onSubmit: (data) => {
    // 更新を呼び出す
    dispatch(updateWelComeInfoRequest({ data }));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeEditWelComeInfoGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(EditWelComeInfoForm);
