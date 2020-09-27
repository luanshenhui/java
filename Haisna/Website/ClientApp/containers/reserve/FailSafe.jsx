import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm } from 'redux-form';
import FailSafeBody from './FailSafeBody';
import PageLayout from '../../layouts/PageLayout';
import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import MessageBanner from '../../components/MessageBanner';
import DatePicker from '../../components/control/datepicker/DatePicker';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import { initializeFailSafe, getFailSafeInfoRequest } from '../../modules/reserve/failSafeModule';
import CircularProgress from '../../components/control/CircularProgress/CircularProgress';

const formName = 'FailSafe';

class FailSafe extends React.Component {
  constructor(props) {
    super(props);
    this.handleSearchClick = this.handleSearchClick.bind(this);
  }

  componentDidMount() {
    const { onLoad } = this.props;
    onLoad();
  }

  // 検索ボタンをクリックする処理
  handleSearchClick(values) {
    const { onSearch } = this.props;
    onSearch(values);
  }

  render() {
    const { message, handleSubmit, totalCount, data, isLoading } = this.props;
    return (
      <PageLayout title="FailSafe">
        {isLoading && <CircularProgress />}
        <form onSubmit={handleSubmit((values) => this.handleSearchClick(values))} >
          <div style={{ textAlign: 'left' }}>
            <FieldGroup itemWidth={100} >
              <FieldSet>
                <span>検索条件を入力して下さい。</span>
              </FieldSet>
              <FieldSet>
                <FieldItem>受診日</FieldItem>
                <Field name="startdate" component={DatePicker} id="startdate" />
                <Label>～</Label>
                <Field name="enddate" component={DatePicker} id="enddate" />
              </FieldSet>
              <FieldSet>
                <Button onClick={handleSubmit((values) => this.handleSearchClick(values))} value="検索" />
              </FieldSet>
              <MessageBanner messages={message} />
            </FieldGroup>
          </div>
          {totalCount !== 0 &&
            <FailSafeBody data={data} count={totalCount} />
          }
        </form>
      </PageLayout>
    );
  }
}

// propTypesの定義
FailSafe.propTypes = {
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  onSearch: PropTypes.func.isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  isLoading: PropTypes.bool.isRequired,
  totalCount: PropTypes.number.isRequired,
};

const FailSafeForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(FailSafe);


const mapStateToProps = (state) => ({
  initialValues: {
    startdate: state.app.reserve.failsafe.failSafeItem.conditions.startdate,
    enddate: state.app.reserve.failsafe.failSafeItem.conditions.enddate,
  },
  totalCount: state.app.reserve.failsafe.failSafeItem.totalCount,
  message: state.app.reserve.failsafe.failSafeItem.message,
  data: state.app.reserve.failsafe.failSafeItem.data,
  isLoading: state.app.reserve.failsafe.failSafeItem.isLoading,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    dispatch(getFailSafeInfoRequest({ ...conditions }));
  },
  onLoad: () => {
    dispatch(initializeFailSafe());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(FailSafeForm));
