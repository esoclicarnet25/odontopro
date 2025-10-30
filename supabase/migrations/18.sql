-- Create agendamentos table
CREATE TABLE public.agendamentos (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  paciente_id UUID NOT NULL,
  dentista_id UUID NOT NULL,
  data_agendamento TIMESTAMP WITH TIME ZONE NOT NULL,
  duracao INTEGER NOT NULL DEFAULT 30,
  procedimento TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'Agendado',
  tipo_atendimento TEXT NOT NULL DEFAULT 'Consulta',
  convenio_id UUID,
  valor NUMERIC,
  observacoes TEXT,
  confirmado BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.agendamentos ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own agendamentos" 
ON public.agendamentos 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own agendamentos" 
ON public.agendamentos 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own agendamentos" 
ON public.agendamentos 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own agendamentos" 
ON public.agendamentos 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_agendamentos_updated_at
BEFORE UPDATE ON public.agendamentos
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Create index for better query performance
CREATE INDEX idx_agendamentos_data ON public.agendamentos(data_agendamento);
CREATE INDEX idx_agendamentos_paciente ON public.agendamentos(paciente_id);
CREATE INDEX idx_agendamentos_dentista ON public.agendamentos(dentista_id);