import React from 'react';
import Moment from 'moment';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { Field, getFormValues, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import MessageBanner from '../../components/MessageBanner';
import PageLayout from '../../layouts/PageLayout';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import Button from '../../components/control/Button';
import DatePicker from '../../components/control/datepicker/DatePicker';
import { initializePerAddUp, getPerAddUpRequest, getUpdPerAddUpRequest, getFreeCountRequest } from '../../modules/preference/freeModule';

const Font = styled.span`
    size: ${(props) => props.size};
    color: #${(props) => props.color};
    strong;
`;
const formName = 'perAddUp';
class PerAddUp extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  componentDidMount() {
    const { onLoad } = this.props;
    onLoad();
  }
  handleSubmit(values, user) {
    const { onSubmit } = this.props;
    let msg = '';
    msg += Moment(values.closeDate).format('YYYY年MM月DD日');
    msg += 'の日次締め処理を実行します。';
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (confirm(msg)) {
      onSubmit({ ...values, user });
    }
  }
  // 描画処理
  render() {
    const { handleSubmit, conditions, dataUser, dataUp, message, isErr } = this.props;
    return (
      <PageLayout title="日次請求締め処理">
        {(message !== undefined && isErr !== 'err') && (<Font color="FF9900" size="14"><strong><MessageBanner messages={message} /></strong></Font>)}
        {(message !== undefined && isErr === 'err') && (<Font color="FF0000" size="14"><strong><MessageBanner messages={message} /></strong></Font>)}
        <form>
          <div>
            <FieldGroup itemWidth={100}>
              <FieldSet>
                <FieldItem>締め日</FieldItem>
                <Field name="closeDate" component={DatePicker} id="" />
              </FieldSet>
              <FieldSet>
                <FieldItem>更新者</FieldItem>
                <Label name="UpdUser">{dataUser.username}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>更新日時</FieldItem>
                <Label name="Upddate">{conditions.Upddate}</Label>
              </FieldSet>
              <FieldSet>
                <Button onClick={handleSubmit((values) => this.handleSubmit(values, dataUp[0].freefield1))} value="確 定" />
              </FieldSet>
            </FieldGroup>
          </div>
        </form>
      </PageLayout>
    );
  }
}

// propTypesの定義
PerAddUp.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  conditions: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string),
  dataUser: PropTypes.shape().isRequired,
  dataUp: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  isErr: PropTypes.string,
};

PerAddUp.defaultProps = {
  message: undefined,
  isErr: '',
};

const PerAddUpForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'PerAddUp',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(PerAddUp);

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    initialValues: {
      closeDate: state.app.preference.free.perAddUp.conditions.closeDate,
      Upddate: state.app.preference.free.perAddUp.conditions.Upddate,
    },
    formValues,
    conditions: state.app.preference.free.perAddUp.conditions,
    dataUser: state.app.preference.free.perAddUp.dataUser,
    data: state.app.preference.free.perAddUp.data,
    dataUp: state.app.preference.free.perAddUp.dataUp,
    message: state.app.preference.free.perAddUp.message,
    isErr: state.app.preference.free.perAddUp.isErr,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onLoad: () => {
    // 画面を初期化
    dispatch(initializePerAddUp());
    const freeCd = 'DAILYCLS';
    dispatch(getPerAddUpRequest({ freeCd }));
    dispatch(getFreeCountRequest({ freeCd }));
  },
  onSubmit: (formValues) => {
    const freefield1 = formValues.user;
    const freeCd = 'DAILYCLS';
    const freedate = formValues.closeDate;
    const freefield2 = formValues.Upddate;
    dispatch(getUpdPerAddUpRequest({ freefield1, freedate, freefield2, freeCd }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(PerAddUpForm));
