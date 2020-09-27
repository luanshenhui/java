import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';

import PageLayout from '../../layouts/PageLayout';
import MessageBanner from '../../components/MessageBanner';
import { initializeBbsEdit, registerBbsRequest } from '../../modules/common/bbsModule';
import DatePicker from '../../components/control/datepicker/DatePicker';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import TextArea from '../../components/control/TextArea';
import TextBox from '../../components/control/TextBox';
import Button from '../../components/control/Button';

const formName = 'entryCommentForm';

class EntryComment extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  componentDidMount() {
    const { onLoad } = this.props;
    onLoad();
  }

  // 戻るボタンクリック時の処理
  handleResetClick() {
    this.props.reset();
  }

  // 登録
  handleSubmit(values) {
    const { history, onSubmit } = this.props;
    onSubmit(values, () => history.replace('/reserve/frontdoor/todaysinfo'));
  }

  render() {
    const { handleSubmit, message } = this.props;

    return (
      <div style={{ marginLeft: '-30px' }}>
        <PageLayout title="コメントの登録">
          <div>
            <MessageBanner messages={message} />
            <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
              <div>
                <Button className="btn" type="submit" value="保存" />
                <Button className="btn" onClick={() => this.handleResetClick()} value="リセット" />
              </div>
              <FieldGroup itemWidth={120}>
                <FieldSet>
                  <FieldItem>表示開始日付</FieldItem>
                  <Field name="strdate" component={DatePicker} id="strdate" />
                </FieldSet>
                <FieldSet>
                  <FieldItem>表示終了日付</FieldItem>
                  <Field name="enddate" component={DatePicker} id="enddate" />
                </FieldSet>
              </FieldGroup>
              <FieldGroup itemWidth={120}>
                <FieldSet>
                  <FieldItem>表題</FieldItem>
                  <Field name="title" component={TextBox} id="title" />
                </FieldSet>
                <FieldSet>
                  <FieldItem>記入者</FieldItem>
                  <Field name="handle" component={TextBox} id="handle" />
                </FieldSet>
                <FieldSet>
                  <FieldItem>コメント</FieldItem>
                  <Field name="message" component={TextArea} id="message" style={{ width: 390, height: 200 }} />
                </FieldSet>
              </FieldGroup>
            </form>
          </div>
        </PageLayout>
      </div>
    );
  }
}

const EntryCommentForm = reduxForm({
  form: formName,
})(EntryComment);

EntryComment.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  reset: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  initialValues: {
    strdate: '',
    enddate: '',
    title: '',
    handle: '',
    message: '',
  },
  message: state.app.common.bbs.bbsEdit.message,
});

const mapDispatchToProps = (dispatch) => ({
  onLoad: () => {
    // 画面を初期化
    dispatch(initializeBbsEdit());
  },
  onSubmit: (data, redirect) => {
    dispatch(registerBbsRequest({ data, redirect }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(EntryCommentForm);

